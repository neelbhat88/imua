var MyBadges = new function()
{
	var self = this;

	self.viewModel = {
		rows: 4,
		cols: 8,
		totalAmount: ko.observable(0),
		getGridBGColor: function(colnum)
		{
			var colorArray = ['#92ed6b', '#5ccccc', '#FFcd73', '#d861c9',
							  '#92ed6b', '#5ccccc', '#FFcd73', '#d861c9'];

			return colorArray[colnum];
		},
		getBadgeBGColor: function(semester)
		{
			var colorArray = ['green', 'blue', 'orange', 'purple',
							  'green', 'blue', 'orange', 'purple'];

			return colorArray[semester - 1];
		}
	};	

	self.init = function()
	{
		$(document).ready(function() {
			//mybadgesinit();

			$.ajax({
				url: '/mybadges',
				data: {rows: self.viewModel.rows, cols: self.viewModel.cols},
				success: function(data) {					
					self.viewModel.gridBadges = ko.mapping.fromJS(data.gridbadges);
					self.viewModel.gridRows = ko.mapping.fromJS(data.gridrows);				

					//ViewModelPropertiesInit(self.viewModel);

					ko.applyBindings(self.viewModel);

					mybadgesinit();

					placeBadges();					
				},
				error: function() { alert("Failed initial MyBadges load");}
			});		
		});		
	};

	function placeBadges()
	{
		jQuery.each(self.viewModel.gridBadges(), function(){
			if (this.gridcellnum() != null)
			{
				var badge = this;
				var badgeElement = $('.badgeSquare[id=' + badge.id() + ']')[0];
				var cellElement = $(".gridCell[cellnum=" + badge.gridcellnum() + "]")[0];
				var cell = ko.dataFor(cellElement);

				cell.isempty(false);
				$(cellElement).addClass('filledSquare');
				
				// Add badge to current container to set parent()		
				$(badgeElement).attr('style', 'position: absolute');
				$(cellElement).append(badgeElement);

				//badgeElement.position( { my: 'left top', at: 'left top', of: $(this) } );
				$(badgeElement).offset({
					left: $(cellElement).position().left,
					top: $(cellElement).position().top
				});			

				updateTotalDollars();
			}
		});
	}

	function mybadgesinit()
	{
		$('.badgeSquare').draggable(
			{
				cursor: 'move',
				containment: '.pageContainer',
				revert: true,
				revertDuration: 300,
				stack: '.badgeSquare'
				//snap: '.emptySquare'
			}
		);

		$('.emptySquare').droppable( 
			{
				accept: '.badgeSquare',
				hoverClass: 'hovered',
				drop: handleEmptySquareDropEvent,
				out: handleOutEvent
			}
		);

		$('.badgesContainer').droppable(
			{
				accept: '.badgeSquare',
				drop: handleBadgesContainerDropEvent,
				out: handleOutEvent
			}			
		);
	}

	function handleEmptySquareDropEvent(event, ui)
	{
		var newSquareElement = this;
		var newSquare = ko.dataFor(this);
		var oldSquareElement = ui.draggable.parent()[0];
		var oldSquare = ko.dataFor(oldSquareElement);
		var badge = ko.dataFor(ui.draggable[0]);

		// If placing on itself
		if (newSquareElement == oldSquareElement)
		{
			ui.draggable.position( { my: 'left top', at: 'left top', of: $(this) } );
			ui.draggable.draggable('option', 'revert', false);			

			return true;
		}

		// Check if piece can be placed
		if (canPlacePiece(newSquare, oldSquareElement, badge))
		{		
			newSquare.isempty(false);
			$(newSquareElement).addClass('filledSquare');
		
			if (!$(oldSquareElement).hasClass('badgesContainer'))
			{
				oldSquare.isempty(true);
				$(oldSquareElement).removeClass('filledSquare');
			}
			
			// Add badge to current container to set parent()		
			ui.draggable.attr('style', 'position: absolute');
			$(this).append(ui.draggable);

			ui.draggable.position( { my: 'left top', at: 'left top', of: $(this) } );
			ui.draggable.draggable('option', 'revert', false);			

			updateTotalDollars();
			updateBadgePosition(badge.id(), newSquare.cellnum(), newSquare.rownum());

			return;
		}	

		return;
	}

	function canPlacePiece(newSquare, previousCellElement, badge) {
		var previousCell = ko.dataFor(previousCellElement);

		var rowBelowNum = newSquare.rownum() + 1;
		var newSquareBelow = getSquareBelow(rowBelowNum, newSquare.colnum());

		var oldSquareAbove = {};
		if ($(previousCellElement).hasClass('badgesContainer'))
		{
			// Default this to true since we don't care about badgesContainer
			oldSquareAbove.isempty = ko.observable(true);
		}
		else
		{
			var rowAboveNum = previousCell.rownum() - 1;
			oldSquareAbove = getSquareAbove(rowAboveNum, previousCell.colnum());
		}		

		var squareFrom = previousCell;

		if (squareFrom != newSquareBelow && // Keep from being able to put current square right above itself
			!newSquareBelow.isempty() && 
			newSquare.isempty() && // Square being placed into should be empty
			oldSquareAbove.isempty() &&
			newSquare.semester() == badge.semester()) 
		{
			return true;
		}

		return false;
	}

	function handleBadgesContainerDropEvent(event, ui)
	{
		var oldSquareElement = ui.draggable.parent()[0];
		var oldSquare = ko.dataFor(oldSquareElement);
		var badge = ko.dataFor(ui.draggable[0]);

		if (!$(oldSquareElement).hasClass('badgesContainer'))
		{
			var oldSquareAbove = getSquareAbove(oldSquare.rownum() - 1, oldSquare.colnum());
		
			// Can't move a square if square on top of it		
			if (!oldSquareAbove.isempty())
				return;
		}		

		// The next three lines had to come before the oldSquare.isempty(true)
		// because that line would make the badge go invisible for some reason
		ui.draggable.draggable('option', 'revert', false);

		ui.draggable.attr('style', 'position: relative');
		$(this).append(ui.draggable);

		if (!$(oldSquareElement).hasClass('badgesContainer'))
		{
			oldSquare.isempty(true);
			$(oldSquareElement).removeClass('filledSquare');
		}

		updateTotalDollars();

		updateBadgePosition(badge.id(), null, null);
	}

	function handleOutEvent(event, ui)
	{
		ui.draggable.draggable('option', 'revert', true);	
	}

	function updateTotalDollars() 
	{
		var total = 0;
		
		$.each($('.filledSquare'), function() {
			total += ko.dataFor(this).value();
		});

		self.viewModel.totalAmount(total);
	}

	function updateBadgePosition(id, cellnum, rownum)
	{
		$.ajax({
			url:'/updateGrid',
			data: {id: id, gridcellnum: cellnum, rownum: rownum},
			// Instead of passing id and cell num, update badge.gridcellnum() and
			// pass the full badge object down and update accordingly
			success: function() {},
			error: function() {alert("updateBadgePosition failed.")}
		});
	}

	// Returns KO object
	function getSquareBelow(rowBelowNum, colNum)
	{
		if (rowBelowNum >= self.viewModel.rows)
		{
			var emptySquare = {};
			emptySquare.isempty = ko.observable(false); // False since we want to be able to place piece here

			return emptySquare;
		}

		var squareBelow = self.viewModel.gridRows()[rowBelowNum].gridcells()[colNum]

		return squareBelow;
	}

	// Returns KO object
	function getSquareAbove(rowAboveNum, colNum)
	{
		if (rowAboveNum < 0)
		{
			var emptySquare = {};
			emptySquare.isempty = ko.observable(true); // True since we want to be able to add and remove a piece here

			return emptySquare;
		}

		var squareAbove = self.viewModel.gridRows()[rowAboveNum].gridcells()[colNum]
		return squareAbove;
	}
};
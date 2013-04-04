var Summary = new function()
{
	var self = this;

	self.init = function()
	{
		$(document).ready(function() {			
			ko.applyBindings(new GridViewModel());

			$('.badgeSquare').draggable(
				{
					cursor: 'move',
					containment: '.pageContainer',
					revert: true,
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
		});
	};
};

function GridViewModel()
{
	var self = this;

	self.rows = ko.observableArray([
			new Row(0, 10), 
			new Row(1, 20), 
			new Row(2, 30),
			new Row(3, 40)
		]);
}

function Row(row, dollarValue)
{
	var self = this;

	self.rowNum = 4 - row;
	self.squares = ko.observableArray([
			new Square(self.rowNum, 0, 0), 
			new Square(self.rowNum, 1, dollarValue), 
			new Square(self.rowNum, 2, 5),
			new Square(self.rowNum, 3, 0)
		]);
}

function Square(rowNum, squareNum, dollarValue)
{
	var self = this;

	self.allValues = [[10, 0, 10, 0],
					  [0, 20, 20, 0],
					  [40, 30, 0, 40],
					  [50, 70, 0, 90]];

	self.dollarValue = ko.observable(self.allValues[rowNum-1][squareNum]);
	self.isEmpty = true;
	self.isLocked = false;

	self.rowNum = ko.observable(rowNum);
	self.squareNum = ko.observable(squareNum);

	self.canPlacePiece = function(previousCellElement) {
		var previousCell = ko.dataFor(previousCellElement);

		var rowBelowNum = self.rowNum() - 1;		
		var newSquareBelow = getSquareBelow(rowBelowNum, self.squareNum());

		var oldSquareAbove = {};
		if ($(previousCellElement).hasClass('badgesContainer'))
		{
			// Default this to true since we don't care about badgesContainer
			oldSquareAbove.isEmpty = true;
		}
		else
		{
			var rowAboveNum = previousCell.rowNum() + 1;
			oldSquareAbove = getSquareAbove(rowAboveNum, previousCell.squareNum());
		}		

		var squareFrom = previousCell;

		if (squareFrom != newSquareBelow && // Keep from being able to put current square right above itself
			!newSquareBelow.isEmpty && 
			self.isEmpty && // Square being placed into should be empty
			oldSquareAbove.isEmpty) 
		{
			return true;
		}

		return false;
	}
}

function handleEmptySquareDropEvent(event, ui)
{
	var newSquareElement = this;
	var newSquare = ko.dataFor(this);
	var oldSquareElement = ui.draggable.parent()[0];
	var oldSquare = ko.dataFor(oldSquareElement);

	// Check if piece can be placed
	if (newSquare.canPlacePiece(oldSquareElement))
	{		
		newSquare.isEmpty = false;
		$(newSquareElement).addClass('filledSquare');
	
		if (!$(oldSquareElement).hasClass('badgesContainer'))
		{
			oldSquare.isEmpty = true;
			$(oldSquareElement).removeClass('filledSquare');
		}
		
		ui.draggable.position( { my: 'left top', at: 'left top', of: $(this) } );
		ui.draggable.draggable('option', 'revert', false);

		// Add badge to current container to set parent()		
		ui.draggable.attr('style', 'position: absolute');
		$(this).append(ui.draggable);

		$('#totalAmount').val(getTotalDollars());
	}
}

function handleBadgesContainerDropEvent(event, ui)
{
	var oldSquareElement = ui.draggable.parent()[0];
	var oldSquare = ko.dataFor(oldSquareElement);

	if (!$(oldSquareElement).hasClass('badgesContainer'))
	{
		oldSquare.isEmpty = true;
		$(oldSquareElement).removeClass('filledSquare');
	}

	ui.draggable.draggable('option', 'revert', false);

	ui.draggable.attr('style', 'position: relative');
	$(this).append(ui.draggable);

	$('#totalAmount').val(getTotalDollars());
}

function handleOutEvent(event, ui)
{
	ui.draggable.draggable('option', 'revert', true);	
}

function getTotalDollars() 
{
	var total = 0;
	
	$.each($('.filledSquare'), function() {
		total += ko.dataFor(this).dollarValue();
	});

	return "$" + total;
}

function getDollarValue(row, col)
{
	var dollarValues = [[10, 0, 10, 0],
						[0, 20, 20, 0],
						[40, 30, 0, 40],
						[50, 70, 0, 90]];
}

// Returns KO object
function getSquareBelow(rowBelowNum, colNum)
{
	if (rowBelowNum <= 0)
	{
		var emptySquare = {};
		emptySquare.isEmpty = false; // False since we want to be able to place piece here

		return emptySquare;
	}

	var mapArray = jQuery.map($('.level'), function(value) { 
				return value.attributes['level'].value == rowBelowNum;
			});

	var index = jQuery.inArray(true, mapArray);
	var level = ko.dataFor($('.level')[index]);
	var squareBelow = level.squares()[colNum];

	return squareBelow;
}

// Returns KO object
function getSquareAbove(rowAboveNum, colNum)
{
	var mapArray = jQuery.map($('.level'), function(value) { 
				return value.attributes['level'].value == rowAboveNum;
			});

	var index = jQuery.inArray(true, mapArray);

	// If no squareAbove return empty object
	if (index == -1)
	{
		var emptySquare = {};
		emptySquare.isEmpty = true;

		return emptySquare;
	}

	var level = ko.dataFor($('.level')[index]);
	var squareAbove = level.squares()[colNum];

	return squareAbove;
}
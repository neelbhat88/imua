var Profile = new function() {
	var self = this;

	self.init = function() {
		$(document).ready(function(){
			$('.filledSquare').draggable(
				{
					cursor: 'move',
					containment: '.pageContainer',
					revert: true,
					stack: '.filledSquare'
					//snap: '.emptySquare'
				}
			);

			$('.emptySquare').droppable( 
				{
					accept: '.filledSquare',
					hoverClass: 'hovered',
					drop: handleEmptySquareDropEvent,
					out: handleOutEvent
				}
			);

			$('.badgesContainer').droppable(
				{
					accept: '.filledSquare',
					drop: handleBadgesContainerDropEvent,
					out: handleOutEvent
				}			
			);

			//ko.applyBindings(new AppViewModel());
		});
	};
};

function handleEmptySquareDropEvent(event, ui)
{
	var slotLevel = $(this).attr('level');
	var badgeLevel = ui.draggable.attr('level');

	//if (slotLevel == badgeLevel)
	//{
		ui.draggable.position( { my: 'left top', at: 'left top', of: $(this) } );
		ui.draggable.draggable('option', 'revert', false);
	//}
}

function handleBadgesContainerDropEvent(event, ui)
{
	//ui.draggable.position( { my: 'left', at: 'left', of: $(this) } );
	ui.draggable.draggable('option', 'revert', false);
}

function handleOutEvent(event, ui)
{
	ui.draggable.draggable('option', 'revert', true);	
}

function AppViewModel() {
	this.firstName = ko.observable("Neel");
	this.lastName = ko.observable("Bhat");
}
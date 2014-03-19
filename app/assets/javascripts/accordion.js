function Accordion()
{
    var self = this;    
}

Accordion.prototype = {
    constructor: Accordion,
    init: function() {
        // Collapse all accordion bodies
        $('.accordionBody').addClass("collapsed").hide();
        
        $('.accordionHeader').click(function(){
            if ($(this).next('.accordionBody').hasClass("collapsed"))
            {
            var parent = $(this).attr('accordion-parent');
            
            // Close all sibling accordions
            $(parent).find('.accordionBody')
                .addClass("collapsed")
                .hide();
            
            $(this).next('.accordionBody')
                .removeClass("collapsed").show();
            }
            else
            {
                $(this).next('.accordionBody')
                .addClass("collapsed").hide();
            }            
        });
    }
}
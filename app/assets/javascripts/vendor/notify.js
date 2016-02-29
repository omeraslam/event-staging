(function($) {

    var defaults = {
       text: 'Success!',
       fadeOutDelay:4000, 
       image: null
    }

    $.notify = function(options) {
        
        var settings = $.extend({}, defaults, options);


       	var container = "<div class='ec-notification'><div class='ec-notification-close remodal-close'></div>";
       	container += "<div class='ec-notification-content'><p>";
        container += settings.text;
        container += "</p></div>";


		if ( settings.image ) {
		    container += "<img src='" + settings.image + "' />";
		}


        container += "</div>";
 
        $("body").append(container);

        window.setTimeout( function() {
			$(".ec-notification").addClass("visible");
			$(".ec-notification-close").bind( "click", function() {
  				$(this).parent(".ec-notification").removeClass("visible");
			});


			window.setTimeout( function() {
				$(".ec-notification").removeClass("visible");
			}, settings.fadeOutDelay);

		}, 100);

        return this;

        
    }
}(jQuery));
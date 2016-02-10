
$( document ).ready(function() {
  $('.event-editor-background .image').removeClass().addClass('image '+ $('#layout_style').val());
  $("#event-share").click(function() {
   $(".event-share").toggle();
 });
  //$("#share-url").val(window.location.href); 
  $("#email-share").attr("href", "mailto:?subject=Join me at my event&body=Join me at my event. Register now at " +  $('#share-url').val() ); 
  $("#twitter-share").attr("href", "http://twitter.com/home?status=Join me at my event. Register now at " +  $('#share-url').val() ); 

  $(".theme").click(function() {
   var theme = $(this).data("theme");
   $(".event-container").addClass(theme);
   if($('.event-editor-background > a.default.highlight').length > 0) {
    $('.event-page').css('background-image', '')
  }

  $('.event-editor-background .image').removeClass().addClass('image '+theme);

});

	//startIntro();

    //contact host modal
    var contactModal = $('#contact-modal').remodal();
    $('.open-contact').click(function(){
    	contactModal.open();
    });

		//contact host modal
		var registrationModal = $('#attendee-form').remodal({hashTracking:false});
		$('.open-registration').click(function(){
			registrationModal.open();
		});






  $('.toggleEditorPanel').click(function() {

    var target = $(this).attr("id");
    var linkActive = $("." + target).hasClass('active');    
    var panelOpen = $('body').hasClass('editor-open');

    
    if (linkActive == false && panelOpen == false) {
      $('body').addClass('editor-open'); 
      
      $(this).addClass('active')
      $("." + target).addClass('active')
      
      $("." + target + " a").each(function(i) {
        $(this).delay((i++) * 50).fadeTo(100, 1); 
      });
      

    }
    else if (linkActive == false && panelOpen == true) {
      console.log('link active false');

      $('.toggleEditorPanel').removeClass('active');
      $(this).addClass('active');


      $('.event-editor-container .active a').each(function(i) {
        $(this).delay((i++) * 50).fadeTo(100, 0); 
      });
      
      $('.event-editor-container .active').removeClass('active');
      
      $("." + target).addClass('active');   
      
      $("." + target + " a").each(function(i) {
       $(this).delay((i++) * 50).fadeTo(100, 1); 
     }); 
      
    }
    else if (linkActive == true && panelOpen == true) {
     console.log('link active true');

     $(this).removeClass('active')

     $('body').removeClass('editor-open');       
     $('.event-editor-container .active a').each(function(i) {
      $(this).delay((i++) * 50).fadeTo(100, 0); 
    });

     $('.event-editor-container .active').removeClass('active');


   } 


 });


  //LOAD THE THEME AND CONSTRUCT

  var theme = $('#layout_style').val()? $('#layout_style').val(): "brunch";   
  var layout = $('#layout_id').val()? $('#layout_id').val(): "1"; 


  $('.theme.active').removeClass("active");
  $('.event-container').removeClass(theme); 
  $('.event-page.' + layout).removeClass('visible'); 

  $('.theme#' + theme).addClass("active");


  $('.event-container').addClass(theme); 
  $('.event-page.' + layout).addClass('visible');    

  
  $('.theme').click(function() {


    $('.theme.active').removeClass("active");
    
    $('.event-container').removeClass(theme); 

    $(this).addClass('active'); 
    layout = $(this).data('layout'); 
    theme = $(this).data('theme'); 


    if($('#layout_style').val() !== theme) {
      $('.save-btn').show();
    }
    
    $('.event-container').addClass(theme); 

    return false;

  });

  // save button 
  $('#save').click(function(e) {
    saveTheme();
  });

  //warning before leave page
  window.onbeforeunload = function(e) {
    if($('#layout_style').val() !== theme) {
      return 'You have unsaved pages. Do you want to leave this page without saving?';
    }
  };
  

  function saveTheme() {
    $.ajax({
      type: 'POST',
        url: String(window.location.href).replace('#', '') + '/updatetheme_post', //testing
        data: {event:{layout_id: layout, layout_style: theme}}
      }).done(function(data){
        console.log(data);
        $('#layout_style').val(theme);
      });
    }

  });

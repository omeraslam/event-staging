
$(document).ready(function(){


    var upgradeOwl = $(".upgrade-owl.owl-carousel").owlCarousel({  
      mouseDrag:false,
        touchDrag:false,
        freeDrag:false,
        pullDrag:false,
        items:1,
        autoHeight : true 
      });
      
      
    //modal
    var upgradeModal = $('#upgrade-modal').remodal();
    $('.open-upgrade').click(function(){
        upgradeModal.open();
    });
    
    //stripe jquery validate plugin https://github.com/stripe/jquery.payment
      
    $('.cc-number').payment('formatCardNumber');
    $('.cc-exp').payment('formatCardExpiry');
    $('.cc-cvc').payment('formatCardCVC');

      function stripeResponseHandler(status, response) {
        alert('help')
        var $form = $('#payment-form');

        if (response.error) {
          // Show the errors on the form
          $form.find('.be-validation').text(response.error.message);
          $form.find('button').prop('disabled', false);
        } else {
          // response contains id and card, which contains additional card details
          var token = response.id;
          // Insert the token into the form so it gets submitted to the server
          $form.append($('<input type="hidden" name="stripeToken" />').val(token));
          // and submit
          $.ajax({
          type: "POST",
          url: $form.attr('action'),
          data: {stripeToken: token, user: {premium: true} },
          success: function() {
          }
        });
          //$form.get(0).submit();
        }
      };

     
     $('#payment-form').submit(function(e){

      var $form = $(this);
      //disable submit button to prevent repeated clicks
      $form.find('button').prop('disabled', true);


       
       e.preventDefault();
       $('input').removeClass('invalid');
         
       var cardType = $.payment.cardType($('.cc-number').val());
       $('.cc-number').toggleClass('invalid', !$.payment.validateCardNumber($('.cc-number').val()));
       $('.cc-exp').toggleClass('invalid', !$.payment.validateCardExpiry($('.cc-exp').payment('cardExpiryVal')));
       $('.cc-cvc').toggleClass('invalid', !$.payment.validateCardCVC($('.cc-cvc').val(), cardType));
     
      // if ( !$('input.invalid').length ) {
          var expgroup = $('.cc-exp').val();
            var expArray = expgroup.split( '/' );
            var expmm = Number($.trim(( expArray[ 0 ] )));
            var expyy = Number($.trim(( expArray[ 1 ] )));

            console.log('"'+ typeof expmm+"|| expmm:"+ expmm +'"')
            console.log('"'+ typeof expyy+"|| expyy:"+ expyy+'"')
            
            //INSERT STRIPE.JS CODE HERE
             var cardObj =  {number: $('#cc').val(),
                    cvc: $('.cc-cvc').val(),
                    exp_month: expmm,
                    exp_year: expyy
                }

             Stripe.card.createToken(cardObj, stripeResponseHandler);


          
            
            //if there are any back end validation issues (ie cc not valid), add to $(".be-validation").html();
            
            //ON SUCCESS, GO TO NEXT SLIDE
            upgradeOwl.trigger('next.owl.carousel');
            
            //should we refresh the page to hide the upgrade links and roadbloacks
            
            
        // }
       });
});


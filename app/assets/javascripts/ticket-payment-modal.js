
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

 

      function stripePuchaseTicketsResponseHandler(status, response) {
    

        $(".full-page-loader").addClass("visible");


        var $form = $('#purchase-tickets_form');
        //purchase_amount, token
        if (response.error) {
          // Show the errors on the form
          $form.find('.be-validation').text(response.error.message);
          $form.find('button').prop('disabled', false);
        } else {
          // response contains id and card, which contains additional card details
          var token = response.id;
          var purchase_amount = $('#purchase_amount').val();

          var plantype = $('#plan_type').val();

          // Insert the token into the form so it gets submitted to the server
          $form.append($('<input type="hidden" name="stripeToken" />').val(token));
          $form.append($('<input type="hidden" name="purchaseAmount" />').val(purchase_amount));
          // and submit
          // 
          

        var data = $form.serialize();
          $.ajax({
          type: "POST",
          url: $form.attr('action'),
          data: data,
          success: function() {

          },
          error: function(resp) {
            console.log(resp);

            $(".full-page-loader").removeClass("visible");
            alert('Sorry, there seems to be a problem processing that credit card. Please try another card.');

            $form.find('button').prop('disabled', false);
          }
        });
          //$form.get(0).submit();
        }
      };



     $('#purchase-tickets_form').submit(function(e) {
      if( $(".cc-number").is(':visible') == true ) {

        e.preventDefault();
       // e.stopImmediatePropagation();
        var $form = $(this);

       // $form.find('button').prop('disabled', true);

        $('input').remove('invalid');


      var cardType = $.payment.cardType($('.cc-number').val());
       $('.cc-number').toggleClass('invalid', !$.payment.validateCardNumber($('.cc-number').val()));
       $('.cc-exp').toggleClass('invalid', !$.payment.validateCardExpiry($('.cc-exp').payment('cardExpiryVal')));
       $('.cc-cvc').toggleClass('invalid', !$.payment.validateCardCVC($('.cc-cvc').val(), cardType));
      
       if ( !$('input.invalid').length && $('.error:visible').length <= 0 ) {
          $form.find('button').prop('disabled', true);
          var expgroup = $('.cc-exp').val();
            var expArray = expgroup.split( '/' );
            var expmm = Number($.trim(( expArray[ 0 ] )));
            var expyy = Number($.trim(( expArray[ 1 ] )));

            
            //INSERT STRIPE.JS CODE HERE
             var cardObj =  {number: $('#cc').val(),
                    cvc: $('.cc-cvc').val(),
                    exp_month: expmm,
                    exp_year: expyy
                }
             Stripe.card.createToken(cardObj, stripePuchaseTicketsResponseHandler);


            return false;
          
            
            //if there are any back end validation issues (ie cc not valid), add to $(".be-validation").html();
            
            //ON SUCCESS, GO TO NEXT SLIDE
            upgradeOwl.trigger('next.owl.carousel');
            
            //should we refresh the page to hide the upgrade links and roadbloacks
            
            
         }

      }

     });


      

     
});


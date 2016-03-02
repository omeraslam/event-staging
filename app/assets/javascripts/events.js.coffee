# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->

  $('#background_form').fileupload
    dataType: "script"
    add: (e, data) ->
      data.context = $(tmpl("template-upload", data.files[0]))
      $('#background_form .uploader').remove()
      $('#background_form').append(data.context)
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded/data.total *100, 10);
        data.context.find('.bar').css('width', progress + '%')
    done: (e, data) -> 
      $('#background_form .uploader .progress').remove();

      newimage = $('#custom-image').find('> div').css('background-image')
      $('.event-page').css 'cssText', 'background-image: '+ newimage + ' !important'





  testInt = setInterval((->
    if $('.time.start').is(':visible')
      clearInterval testInt
      #initialize date time
      $('#datepairExample .time.start').timepicker
        'showDuration': true
        'timeFormat': 'g:ia'
        appendTo: '.start-time'
      $('#datepairExample .time.end').timepicker
        'showDuration': true
        'timeFormat': 'g:ia'
        appendTo: '.end-time'
      $('#datepairExample .date').datepicker
          onSelect: (dateText) ->
            $('.date').focusout()
            return
          'format': 'm/d/yyyy'
          'autoclose': true
        # # initialize datepair
      $('#datepairExample').datepair
        parseDate: (input) ->
          $(input).datepicker 'getDate'
        updateDate: (input, dateObj) ->
          $(input).datepicker 'setDate', dateObj


    return
  ), 1000)


  initButton = $('.event-editor-background a.highlight').hasClass('default')

  $('.event-editor-background a').on 'click', (e) ->
    #e.preventDefault()

  


      $('.event-editor-background a').removeClass 'highlight'
      $(this).addClass 'highlight'
      if(initButton ==  $(this).hasClass('default') ) 
        $('.save-btn').show()
      #return

      newimage = $(this).find('> div').css('background-image')
      $('.event-page').css 'cssText', 'background-image: '+ newimage.replace('_thumb', '_bg') + ' !important'

      alert String(window.location.href).replace('?first=true', '')
      $.ajax(
        type: 'POST'
        url: '' + String(window.location.href).replace('?first=true', '').replace('#', '') + '/updatetheme_post'
        data: event: show_custom: $('.default.highlight').length <= 0).done (data) ->
        return

  if $('#show_custom').val() == 'false' || $('#show_custom').val() == ''
    $('a.default').addClass('highlight')
    newimage = $('a.default').find('> div').css('background-image')
    $('.event-page').css 'cssText', ''
  else
    $('a#custom-image').addClass('highlight')
    newimage = $('#bg').val()
    $('.event-page').css 'cssText', 'background-image: url('+ newimage + ') !important'

  $('.event-editor-design a').on 'click', (e) ->
    e.preventDefault()
    $('.event-editor-design a').removeClass 'highlight'
    $(this).addClass 'highlight'

    # newimage = $(this).find('> div').css('background-image')
    # $('.event-page').css 'cssText', 'background-image: '+ newimage + ' !important'

    return



  $(document).ready ->
    #$.datepicker.setDefaults
     # 'dateFormat': 'yy-mm-dd'
    if $('.signed-in').length > 0 && $('.event-editor-container').length > 0
      jQuery('.best_in_place').best_in_place()

      $('span[data-bip-attribute="name"]').bind 'focusin', ->
        $('.visible span[data-bip-attribute="name"] input').val $('.visible span[data-bip-attribute="name"]').attr('data-bip-value')
        return

      $('span[data-bip-attribute="description"]').bind 'focusin', ->
        $('.visible span[data-bip-attribute="description"] textarea').val $('.visible span[data-bip-attribute="description"]').attr('data-bip-value')
        return


      $('h1 span[data-bip-attribute="name"]').bind 'ajax:success', ->
        $('h1 span[data-bip-attribute="name"]').text($('.visible h1 span[data-bip-attribute="name"]').text())
        $('h1 span[data-bip-attribute="name"]').attr('data-bip-original-content', $('.visible span[data-bip-attribute="name"]').text())
        $('h1 span[data-bip-attribute="name"]').attr('data-bip-value', $('.visible h1 span[data-bip-attribute="name"]').text())
        return

      $('span[data-bip-attribute="description"]').bind 'ajax:success', ->
        
        $('span[data-bip-attribute="description"]').text($('.visible span[data-bip-attribute="description"]').text())
        $('span[data-bip-attribute="description"]').attr('data-bip-original-content', $('.visible span[data-bip-attribute="description"]').text())
        $('span[data-bip-attribute="description"]').attr('data-bip-value', $('.visible span[data-bip-attribute="description"]').text())
        return
      return
    return


  
  $('input[type=radio]:checked').parent().find('img').addClass('active')




  $('.ui-datepicker-calendar tbody td a').on 'click', (e) ->
    $('.date').focusout()
    return
 
  $('#cb_time').on 'click', (e) ->
    if($('.date, .time').attr('disabled'))
      $('.date, .time').attr('disabled', false)
      $('.date, .time').removeAttr('disabled')
      $('.date.start').focus()
    else
      $('.date, .time').attr('disabled', true);

  #   return
 

  $('#default_bg_picker img').on 'click', (e) ->
    e.preventDefault()
    $('#default_bg_picker img').removeClass('active')
    $(this).addClass('active')
    $(this).parent().find('input[type="radio"]').click()
    #$('#style_id').val($(this).data('theme'))
  return
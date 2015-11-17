# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->

  $('#datepairExample .time').timepicker
    'showDuration': true
    'timeFormat': 'g:ia'
  $('#datepairExample .date').datepicker
    'format': 'm/d/yyyy'
    'autoclose': true
  # # initialize datepair
  $('#datepairExample').datepair
    parseDate: (input) ->
      $(input).datepicker 'getDate'
    updateDate: (input, dateObj) ->
      $(input).datepicker 'setDate', dateObj

  #$('.date').focus()







  $(document).ready ->
    $.datepicker.setDefaults
      'dateFormat': 'yy-mm-dd'

    jQuery('.best_in_place').best_in_place()

    $('span[data-bip-attribute="name"]').bind 'focusin', ->
      console.log $('.visible span[data-bip-attribute="name"]').attr('data-bip-value')
      $('.visible span[data-bip-attribute="name"] input').val $('.visible span[data-bip-attribute="name"]').attr('data-bip-value')
      return

    $('span[data-bip-attribute="description"]').bind 'focusin', ->
      console.log $('.visible span[data-bip-attribute="description"]').attr('data-bip-value')
      $('.visible span[data-bip-attribute="description"] textarea').val $('.visible span[data-bip-attribute="description"]').attr('data-bip-value')
      console.log 'val' + $('.visible span[data-bip-attribute="description"] textarea').val
      return


    $('h1 span[data-bip-attribute="name"]').bind 'ajax:success', ->
      $('h1 span[data-bip-attribute="name"]').text($('.visible h1 span[data-bip-attribute="name"]').text())
      $('h1 span[data-bip-attribute="name"]').attr('data-bip-original-content', $('.visible span[data-bip-attribute="name"]').text())
      $('h1 span[data-bip-attribute="name"]').attr('data-bip-value', $('.visible h1 span[data-bip-attribute="name"]').text())
      return

    $('span[data-bip-attribute="description"]').bind 'ajax:success', ->
      alert $('.visible span[data-bip-attribute="description"]').text()
      $('span[data-bip-attribute="description"]').text($('.visible span[data-bip-attribute="description"]').text())
      $('span[data-bip-attribute="description"]').attr('data-bip-original-content', $('.visible span[data-bip-attribute="description"]').text())
      $('span[data-bip-attribute="description"]').attr('data-bip-value', $('.visible span[data-bip-attribute="description"]').text())
      return






    return



  
  $('input[type=radio]:checked').parent().find('img').addClass('active')



  if($('#cb_time').attr('checked'))
    $('.date, .time').attr('disabled', true);
  else
    $('.date, .time').attr('disabled', false);
    $('.date, .time').removeAttr('disabled');

  $('form#new_event .slide-up-show input, form.edit_event .slide-up-show input').focus()
  $('#new_event, form.edit_event').validate
    onfocusout: (element) ->
      $(element).valid()
      return
    debug: false
    rules:
      'event[name]':
        required: true
      'event[location]':
        required: true
      'event[description]':
        required: true
    messages:
      'event[name]':
        required: 'Please enter a name'
      'event[location]':
        required: 'Where\'s the party at?'
      'event[description]':
        required: 'Please enter a description'

  $('#new_attendee').validate
    debug: false
    rules:
      'attendee[first_name]':
        required: true
      'attendee[last_name]':
        required: true
      'attendee[email]':
        required: true
      'attendee[phone_number]':
        required: true
    messages:
      'attendee[first_name]':
        required: 'Please enter a first name'
      'attendee[last_name]':
        required: 'Please enter a last name'
      'attendee[email]':
        required: 'Please enter an email'
      'attendee[phone_number]':
        required: 'Please enter a phone number'



  if $('#eventPage').length != 0

    img = document.getElementById('eventPage')
    if img.currentStyle != 0
      style = img.currentStyle or window.getComputedStyle(img, false)
      bi = style.backgroundImage.slice(4, -1)
      bi = style.backgroundImage.slice(4, -1).replace(/"/g, '')
      
      sourceImage =  bi

    oImg = document.createElement('img')
    oImg.setAttribute 'src', bi
    oImg.setAttribute 'width', '100px'
    oImg.setAttribute 'height', '100px'
    oImg.crossOrigin = '';
    oImg.setAttribute  'crossOrigin', 'anonymous'

     
    
   #oImg.onload = ->
   #  `var colorThief`
   #  colorThief = new ColorThief
   #  photoColor = colorThief.getColor(oImg)


   #  $('.btn-bordered').removeClass 'hover-color'
   #  $('.btn-bordered').hover(
   #    (ev) -> $(this).css('color', 'rgb(' + photoColor[0] + ',' + photoColor[1] + ',' + photoColor[2] + ')');
   #    (ev) -> $(this).css('color', 'rgb(255,255,255)');
   #  )


   #   $('#attendee-form').css 'backgroundColor', 'rgb(' + photoColor[0] + ',' + photoColor[1] + ',' + photoColor[2] + ')'
    #  return


  scrollToAnchor = (aid) ->
    aTag = $('div[name=\'' + aid + '\']')

    console.log aTag
    $('html,body').animate { scrollTop: aTag.offset().top }, 'slow'
    return

  $('.rsvp, .more').on 'click', ->
    scrollToAnchor 'attendee-form'
    return

  $('.checkmarks .yes').on 'click', (e) ->
    e.preventDefault()
    $('#attendee_attending_true').click()
    return


  $('.checkmarks .no').on 'click', (e) ->
    e.preventDefault()
    $('#attendee_attending_false').click()
    return


  formArray = $('.event-registration .field')
  percentRange = 100 / formArray.length
  currentIndex = 0
  $('.event-registration .field').addClass 'slide-down-hide'
  $(formArray[0]).removeClass('slide-down-hide').addClass 'slide-up-show'
  $('.event-preview').hide()


  $('.percent span').animate { 'width': (currentIndex + 1) * percentRange + '%' }, 500
  $('.side-nav li a').on 'click', (e) ->
   
    e.preventDefault()
    $('.side-nav li a').removeClass 'active'
    $(this).addClass 'active'
    if currentIndex < $(this).parent().index()
      $('.event-registration .field').removeClass('slide-up-hide slide-up-show slide-down-show').addClass 'slide-up-hide'
    else
      $('.event-registration .field').removeClass('slide-up-hide slide-up-show slide-down-show').addClass 'slide-down-hide'
    currentIndex = $(this).parent().index()
    $(formArray[currentIndex]).removeClass('slide-up-hide slide-down-hide').addClass 'slide-up-hide'
    $(formArray[currentIndex]).removeClass('slide-down-hide slide-up-hide').addClass 'slide-up-show'
    $('.percent span').animate { 'width': (currentIndex + 1) * percentRange + '%' }, 500
  

    return
  $('#btn-create').hide()
  checkStep = ->
    if currentIndex < formArray.length - 1
      $('#btn-create').hide()
      $('.btn-next').show()
    else
      $('#btn-create').show()
      $('.btn-next').hide()
    return

 
  $('#cb_time').on 'click', (e) ->
    if($('.date, .time').attr('disabled'))
      $('.date, .time').attr('disabled', false)
      $('.date, .time').removeAttr('disabled')
    else
      $('.date, .time').attr('disabled', true);

  #   return
  $('.btn-prev').on 'click', (e) ->
    e.preventDefault()
    $('.side-nav li a.active').parent().prev().find('a').click()
    checkStep()
    return
  $('.btn-next').on 'click', (e) ->
    e.preventDefault()

    if($('.slide-up-show .error:visible').length <= 0)
      $('.side-nav li a.active').parent().next().find('a').click()
      setTimeout (->
        if $('.slide-up-show input.date.start:visible').length <= 0
          $('form#new_event .slide-up-show input, form#new_event .slide-up-show textarea, form.edit_event .slide-up-show input, form.edit_event .slide-up-show textarea').focus()
        return
      ), 400
    checkStep()
    return

  #keyboard navigation on event flow
  $(document).keyup (event) ->

    $('.slide-up-show input').focusout()
    key = event.which
    switch key
      when 37
        # Key left.
        if !$('.slide-up-show input').is(':focus')
          $('.btn-prev').click()
      when 38
        # Key up.
        console.log 'up'
      when 39, 13
        # Key right.
        console.log 'right'
        if !$('.slide-up-show input').is(':focus')
          $('.btn-next').click()
      when 40
        # Key down.
        console.log 'down'
    return

  $('.side-nav li a').each ->
    tooltipText = $(this).data('tooltip')
    html = '<span>' + tooltipText + '</span>'
    $(this).append html
    return

  $('#default_bg_picker img').on 'click', (e) ->
    e.preventDefault()
    $('#default_bg_picker img').removeClass('active')
    $(this).addClass('active')
    $(this).parent().find('input[type="radio"]').click()
    #$('#style_id').val($(this).data('theme'))
  return

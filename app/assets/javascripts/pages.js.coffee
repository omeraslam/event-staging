# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->

    images = $('.bg-overlay')
    i = 0
    while i < images.length
      image = '/assets/home/' + $(images[i]).data('image')
      $(images[i]).css 'background-image', 'url(' + image + ')'
      i++
    $('.feature').hover (->
      $(images[$(this).index() - 1]).fadeIn 500
      return
    ), ->
      $(images[$(this).index() - 1]).fadeOut 50
      return
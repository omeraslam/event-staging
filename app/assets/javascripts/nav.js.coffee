$(document).on 'ready page:load', ->

#    images = $('.bg-overlay')
#    i = 0
#    while i < images.length
#      image = '/assets/home/' + $(images[i]).data('image')
#      $(images[i]).css 'background-image', 'url(' + image + ')'
#      i++
#    $('.feature').hover (->
#      $(images[$(this).index() - 1]).fadeIn 500
#      return
#    ), ->
#      $(images[$(this).index() - 1]).fadeOut 50
#      return
  #if $('.dashboard').length <= 0 
      $('.open-menu, .cover').click (e) ->
        $('nav').toggleClass 'menu-open'
        e.preventDefault()
        return
      return
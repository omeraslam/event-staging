# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->

    #get event object for dropdown on dashboard

    $ ->
      source = []
      $.ajax(
        url: '/dashboard'
        dataType: 'json'
        type: 'GET').done (response) ->
        i = response.length - 1
        while i >= 0
          obj = 
            target: '/dashboard/event?event=' + response[i].id
            value: response[i].name
          source.push obj
          i--

    #initialize autocomplete on dropdown
        $('#tags').autocomplete(
          source: source
          minLength: 0
          select: (event, ui) ->
            window.location.href = ui.item.target
            return
        ).focus ->
          $(this).autocomplete 'search'
          return
        return
      return

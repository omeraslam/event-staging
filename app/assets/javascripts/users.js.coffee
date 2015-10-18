# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $('#new_user').validate
    debug: false
    rules:
      'user[email]':
        required: true
        email: true
      'user[password]':
        required: true
        minlength: 6
      'user[password_confirmation]':
        required: true
        equalTo: '#user_password'
    messages:
      'user[email]':
        required: 'Enter an email address'
        email: 'Enter a valid email address'
      'user[password]':
        required: 'Enter a password'
        minlength: 'Enter a password more than 6 characters'
      'user[password_confirmation]':
        required: 'Please enter a confirmation password'
        equalTo: 'Passwords do not match'
  return
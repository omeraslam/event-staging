(function(){$(document).on("ready page:load",function(){$("#new_user").validate({debug:!1,rules:{"user[email]":{required:!0,email:!0},"user[password]":{required:!0,minlength:6},"user[password_confirmation]":{required:!0,equalTo:"#user_password"}},messages:{"user[email]":{required:"Enter an email address",email:"Enter a valid email address"},"user[password]":{required:"Enter a password",minlength:"Enter a password more than 6 characters"},"user[password_confirmation]":{required:"Please enter a confirmation password",equalTo:"Passwords do not match"}}})})}).call(this);
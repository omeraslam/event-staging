(function(){$(document).on("ready page:load",function(){var e,t,a,i,n,d;$("#background_form").fileupload({dataType:"script",add:function(e,t){return t.context=$(tmpl("template-upload",t.files[0])),$("#background_form .uploader").remove(),$("#background_form").append(t.context),t.submit()},progress:function(e,t){var a;return t.context?(a=parseInt(t.loaded/t.total*100,10),t.context.find(".bar").css("width",a+"%")):void 0},done:function(e,t){var a;return $("#background_form .uploader .progress").remove(),a=$("#custom-image").find("> div").css("background-image"),$(".event-page").css("cssText","background-image: "+a+" !important")}}),$("#datepairExample .time").timepicker({showDuration:!0,timeFormat:"g:ia"}),$("#datepairExample .date").datepicker({onSelect:function(e){$(".date").focusout()},format:"m/d/yyyy",autoclose:!0}),$("#datepairExample").datepair({parseDate:function(e){return $(e).datepicker("getDate")},updateDate:function(e,t){return $(e).datepicker("setDate",t)}}),$(".event-editor-background a").on("click",function(e){var t;return $(".event-editor-background a").removeClass("highlight"),$(this).addClass("highlight"),t=$(this).find("> div").css("background-image"),$(".event-page").css("cssText","background-image: "+t+" !important"),$.ajax({type:"POST",url:String(window.location.href).replace("#","")+"/updatetheme",data:{event:{show_custom:$(".default.highlight").length<=0}}}).done(function(e){})}),"false"===$("#show_custom").val()||""===$("#show_custom").val()?($("a.default").addClass("highlight"),i=$("a.default").find("> div").css("background-image"),$(".event-page").css("cssText","")):($("a#custom-image").addClass("highlight"),i=$("#bg").val(),$(".event-page").css("cssText","background-image: url("+i+") !important")),$(".event-editor-design a").on("click",function(e){e.preventDefault(),$(".event-editor-design a").removeClass("highlight"),$(this).addClass("highlight")}),$(document).ready(function(){return $(".signed-in").length>0&&$(".event-editor-container").length>0?(jQuery(".best_in_place").best_in_place(),$('span[data-bip-attribute="name"]').bind("focusin",function(){$('.visible span[data-bip-attribute="name"] input').val($('.visible span[data-bip-attribute="name"]').attr("data-bip-value"))}),$('span[data-bip-attribute="description"]').bind("focusin",function(){$('.visible span[data-bip-attribute="description"] textarea').val($('.visible span[data-bip-attribute="description"]').attr("data-bip-value"))}),$('h1 span[data-bip-attribute="name"]').bind("ajax:success",function(){$('h1 span[data-bip-attribute="name"]').text($('.visible h1 span[data-bip-attribute="name"]').text()),$('h1 span[data-bip-attribute="name"]').attr("data-bip-original-content",$('.visible span[data-bip-attribute="name"]').text()),$('h1 span[data-bip-attribute="name"]').attr("data-bip-value",$('.visible h1 span[data-bip-attribute="name"]').text())}),void $('span[data-bip-attribute="description"]').bind("ajax:success",function(){$('span[data-bip-attribute="description"]').text($('.visible span[data-bip-attribute="description"]').text()),$('span[data-bip-attribute="description"]').attr("data-bip-original-content",$('.visible span[data-bip-attribute="description"]').text()),$('span[data-bip-attribute="description"]').attr("data-bip-value",$('.visible span[data-bip-attribute="description"]').text())})):void 0}),$("input[type=radio]:checked").parent().find("img").addClass("active"),$("#cb_time").attr("checked")?$(".date, .time").attr("disabled",!0):($(".date, .time").attr("disabled",!1),$(".date, .time").removeAttr("disabled")),$("form#new_event .slide-up-show input, form.edit_event .slide-up-show input").focus(),$("#new_event, form.edit_event").validate({onfocusout:function(e){$(e).valid()},debug:!1,rules:{"event[name]":{required:!0},"event[date_start]":{required:!0},"event[time_start]":{required:!0},"event[time_end]":{required:!0},"event[location]":{required:!0},"event[description]":{required:!0}},messages:{"event[name]":{required:"Please enter a name"},"event[location]":{required:"Where's the party at?"},"event[description]":{required:"Please enter a description"}}}),$("#new_attendee").validate({debug:!1,rules:{"attendee[first_name]":{required:!0},"attendee[last_name]":{required:!0},"attendee[email]":{required:!0},"attendee[phone_number]":{required:!0}},messages:{"attendee[first_name]":{required:"Please enter a first name"},"attendee[last_name]":{required:"Please enter a last name"},"attendee[email]":{required:"Please enter an email"},"attendee[phone_number]":{required:"Please enter a phone number"}}}),d=function(e){var t;t=$("div[name='"+e+"']"),$("html,body").animate({scrollTop:t.offset().top},"slow")},$(".rsvp, .more").on("click",function(){d("attendee-form")}),$(".checkmarks .yes").on("click",function(e){e.preventDefault(),$("#attendee_attending_true").click()}),$(".checkmarks .no").on("click",function(e){e.preventDefault(),$("#attendee_attending_false").click()}),a=$(".event-registration .field"),n=100/a.length,t=0,$(".event-registration .field").addClass("slide-down-hide"),$(a[0]).removeClass("slide-down-hide").addClass("slide-up-show"),$(".event-preview").hide(),$(".percent span").animate({width:(t+1)*n+"%"},500),$(".side-nav li a").on("click",function(e){e.preventDefault(),$(".side-nav li a").removeClass("active"),$(this).addClass("active"),t<$(this).parent().index()?$(".event-registration .field").removeClass("slide-up-hide slide-up-show slide-down-show").addClass("slide-up-hide"):$(".event-registration .field").removeClass("slide-up-hide slide-up-show slide-down-show").addClass("slide-down-hide"),t=$(this).parent().index(),$(a[t]).removeClass("slide-up-hide slide-down-hide").addClass("slide-up-hide"),$(a[t]).removeClass("slide-down-hide slide-up-hide").addClass("slide-up-show"),$(".percent span").animate({width:(t+1)*n+"%"},500)}),$("#btn-create").hide(),e=function(){t<a.length-1?($("#btn-create").hide(),$(".btn-next").show()):($("#btn-create").show(),$(".btn-next").hide())},$(".ui-datepicker-calendar tbody td a").on("click",function(e){$(".date").focusout()}),$("#cb_time").on("click",function(e){return $(".date, .time").attr("disabled")?($(".date, .time").attr("disabled",!1),$(".date, .time").removeAttr("disabled"),$(".date.start").focus()):$(".date, .time").attr("disabled",!0)}),$(".btn-prev").on("click",function(t){t.preventDefault(),$(".side-nav li a.active").parent().prev().find("a").click(),e()}),$(".btn-next").on("click",function(t){t.preventDefault(),$(".slide-up-show .error:visible").length<=0&&($(".side-nav li a.active").parent().next().find("a").click(),setTimeout(function(){$(".slide-up-show input.date.start:visible").length<=0&&$("form#new_event .slide-up-show input, form#new_event .slide-up-show textarea, form.edit_event .slide-up-show input, form.edit_event .slide-up-show textarea").focus()},400)),e()}),$(document).keyup(function(e){var t;switch($(".slide-up-show input").focusout(),t=e.which){case 37:$(".slide-up-show input").is(":focus")||$(".btn-prev").click();break;case 39:case 13:console.log("hello"),$(".slide-up-show input").is(":focus")||(console.log("next"),$(".btn-next").click())}}),$(".side-nav li a").each(function(){var e,t;t=$(this).data("tooltip"),e="<span>"+t+"</span>",$(this).append(e)}),$("#default_bg_picker img").on("click",function(e){return e.preventDefault(),$("#default_bg_picker img").removeClass("active"),$(this).addClass("active"),$(this).parent().find('input[type="radio"]').click()})})}).call(this);
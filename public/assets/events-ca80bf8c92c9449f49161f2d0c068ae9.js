(function(){$(document).on("ready page:load",function(){var t,a;$("#background_form").fileupload({dataType:"script",add:function(t,a){return a.context=$(tmpl("template-upload",a.files[0])),$("#background_form .uploader").remove(),$("#background_form").append(a.context),a.submit()},progress:function(t,a){var e;return a.context?(e=parseInt(a.loaded/a.total*100,10),a.context.find(".bar").css("width",e+"%")):void 0},done:function(t,a){var e;return $("#background_form .uploader .progress").remove(),e=$("#custom-image").find("> div").css("background-image"),$(".event-page").css("cssText","background-image: "+e+" !important")}}),a=setInterval(function(){$(".time.start").is(":visible")&&(clearInterval(a),$("#datepairExample .time.start").timepicker({showDuration:!0,timeFormat:"g:ia"}),$("#datepairExample .date").datepicker({onSelect:function(t){$(".date").focusout()},format:"m/d/yyyy",autoclose:!0}),$("#datepairExample").datepair({parseDate:function(t){return $(t).datepicker("getDate")},updateDate:function(t,a){return $(t).datepicker("setDate",a)}}))},1e3),$(".event-editor-background a").on("click",function(t){var a;return $(".event-editor-background a").removeClass("highlight"),$(this).addClass("highlight"),a=$(this).find("> div").css("background-image"),$(".event-page").css("cssText","background-image: "+a.replace("_thumb","_bg")+" !important"),$.ajax({type:"POST",url:""+String(window.location.href).replace("?first=true","").replace("#","")+"/updatetheme_post",data:{event:{show_custom:$(".default.highlight").length<=0}}}).done(function(t){})}),"false"===$("#show_custom").val()||""===$("#show_custom").val()?($("a.default").addClass("highlight"),t=$("a.default").find("> div").css("background-image"),$(".event-page").css("cssText","")):($("a#custom-image").addClass("highlight"),t=$("#bg").val(),$(".event-page").css("cssText","background-image: url("+t+") !important")),$(".event-editor-design a").on("click",function(t){t.preventDefault(),$(".event-editor-design a").removeClass("highlight"),$(this).addClass("highlight")}),$(document).ready(function(){return $(".signed-in").length>0&&$(".event-editor-container").length>0?(jQuery(".best_in_place").best_in_place(),$('span[data-bip-attribute="name"]').bind("focusin",function(){$('.visible span[data-bip-attribute="name"] input').val($('.visible span[data-bip-attribute="name"]').attr("data-bip-value"))}),$('span[data-bip-attribute="description"]').bind("focusin",function(){$('.visible span[data-bip-attribute="description"] textarea').val($('.visible span[data-bip-attribute="description"]').attr("data-bip-value"))}),$('h1 span[data-bip-attribute="name"]').bind("ajax:success",function(){$('h1 span[data-bip-attribute="name"]').text($('.visible h1 span[data-bip-attribute="name"]').text()),$('h1 span[data-bip-attribute="name"]').attr("data-bip-original-content",$('.visible span[data-bip-attribute="name"]').text()),$('h1 span[data-bip-attribute="name"]').attr("data-bip-value",$('.visible h1 span[data-bip-attribute="name"]').text())}),void $('span[data-bip-attribute="description"]').bind("ajax:success",function(){$('span[data-bip-attribute="description"]').text($('.visible span[data-bip-attribute="description"]').text()),$('span[data-bip-attribute="description"]').attr("data-bip-original-content",$('.visible span[data-bip-attribute="description"]').text()),$('span[data-bip-attribute="description"]').attr("data-bip-value",$('.visible span[data-bip-attribute="description"]').text())})):void 0}),$("input[type=radio]:checked").parent().find("img").addClass("active"),$(".ui-datepicker-calendar tbody td a").on("click",function(t){$(".date").focusout()}),$("#cb_time").on("click",function(t){return $(".date, .time").attr("disabled")?($(".date, .time").attr("disabled",!1),$(".date, .time").removeAttr("disabled"),$(".date.start").focus()):$(".date, .time").attr("disabled",!0)}),$("#default_bg_picker img").on("click",function(t){return t.preventDefault(),$("#default_bg_picker img").removeClass("active"),$(this).addClass("active"),$(this).parent().find('input[type="radio"]').click()})})}).call(this);
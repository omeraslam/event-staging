!function(e){"function"==typeof define&&define.amd?define(["jquery"],e):"object"==typeof module&&module.exports?module.exports=function(t,n){return void 0===n&&(n="undefined"!=typeof window?require("jquery"):require("jquery")(t)),e(n),n}:e(jQuery)}(function(e){"use strict";e.extend(e.FE.POPUP_TEMPLATES,{"link.edit":"[_BUTTONS_]","link.insert":"[_BUTTONS_][_INPUT_LAYER_]"}),e.extend(e.FE.DEFAULTS,{linkEditButtons:["linkOpen","linkStyle","linkEdit","linkRemove"],linkInsertButtons:["linkBack","|","linkList"],linkAttributes:{},linkAutoPrefix:"http://",linkStyles:{"fr-green":"Green","fr-strong":"Thick"},linkMultipleStyles:!0,linkConvertEmailAddress:!0,linkAlwaysBlank:!1,linkAlwaysNoFollow:!1,linkList:[{text:"Froala",href:"https://froala.com",target:"_blank"},{text:"Google",href:"https://google.com",target:"_blank"},{displayText:"Facebook",href:"https://facebook.com"}],linkText:!0}),e.FE.PLUGINS.link=function(t){function n(){var n=t.image?t.image.get():null;if(!n&&t.$wp){var i=t.selection.element(),r=t.selection.endElement();return"A"==i.tagName||t.node.isElement(i)||(i=e(i).parentsUntil(t.$el,"a:first").get(0)),"A"==r.tagName||t.node.isElement(r)||(r=e(r).parentsUntil(t.$el,"a:first").get(0)),r&&r==i&&"A"==r.tagName?i:null}return"A"==t.$el.get(0).tagName&&t.core.hasFocus()?t.$el.get(0):n&&n.get(0).parentNode&&"A"==n.get(0).parentNode.tagName?n.get(0).parentNode:void 0}function i(){var e=t.image?t.image.get():null,n=[];if(e)"A"==e.get(0).parentNode.tagName&&n.push(e.get(0).parentNode);else{var i,r,a,l;if(t.win.getSelection){var s=t.win.getSelection();if(s.getRangeAt&&s.rangeCount){l=t.doc.createRange();for(var o=0;o<s.rangeCount;++o)if(i=s.getRangeAt(o),r=i.commonAncestorContainer,r&&1!=r.nodeType&&(r=r.parentNode),r&&"a"==r.nodeName.toLowerCase())n.push(r);else{a=r.getElementsByTagName("a");for(var p=0;p<a.length;++p)l.selectNodeContents(a[p]),l.compareBoundaryPoints(i.END_TO_START,i)<1&&l.compareBoundaryPoints(i.START_TO_END,i)>-1&&n.push(a[p])}}}else if(t.doc.selection&&"Control"!=t.doc.selection.type)if(i=t.doc.selection.createRange(),r=i.parentElement(),"a"==r.nodeName.toLowerCase())n.push(r);else{a=r.getElementsByTagName("a"),l=t.doc.body.createTextRange();for(var f=0;f<a.length;++f)l.moveToElementText(a[f]),l.compareEndPoints("StartToEnd",i)>-1&&l.compareEndPoints("EndToStart",i)<1&&n.push(a[f])}}return n}function r(i){l(),setTimeout(function(){if(!i||i&&(1==i.which||"mouseup"!=i.type)){var r=n(),l=t.image?t.image.get():null;if(r&&!l){if(t.image){var s=t.node.contents(r);if(1==s.length&&"IMG"==s[0].tagName){var o=t.selection.ranges(0);return 0===o.startOffset&&0===o.endOffset?e(r).before(e.FE.MARKERS):e(r).after(e.FE.MARKERS),t.selection.restore(),!1}}i&&i.stopPropagation(),a(r)}}},t.helpers.isIOS()?100:0)}function a(n){var i=t.popups.get("link.edit");i||(i=s());var r=e(n);t.popups.isVisible("link.edit")||t.popups.refresh("link.edit"),t.popups.setContainer("link.edit",e(t.opts.scrollableContainer));var a=r.offset().left+e(n).outerWidth()/2,l=r.offset().top+r.outerHeight();t.popups.show("link.edit",a,l,r.outerHeight())}function l(){t.popups.hide("link.edit")}function s(){var e="";t.opts.linkEditButtons.length>1&&("A"==t.$el.get(0).tagName&&t.opts.linkEditButtons.indexOf("linkRemove")>=0&&t.opts.linkEditButtons.splice(t.opts.linkEditButtons.indexOf("linkRemove"),1),e='<div class="fr-buttons">'+t.button.buildList(t.opts.linkEditButtons)+"</div>");var i={buttons:e},r=t.popups.create("link.edit",i);return t.$wp&&t.events.$on(t.$wp,"scroll.link-edit",function(){n()&&t.popups.isVisible("link.edit")&&a(n())}),r}function o(){}function p(){var i=t.popups.get("link.insert"),r=n();if(r){var a,l,s=e(r),o=i.find('input.fr-link-attr[type="text"]'),p=i.find('input.fr-link-attr[type="checkbox"]');for(a=0;a<o.length;a++)l=e(o[a]),l.val(s.attr(l.attr("name")||""));for(p.prop("checked",!1),a=0;a<p.length;a++)l=e(p[a]),s.attr(l.attr("name"))==l.data("checked")&&l.prop("checked",!0);i.find('input.fr-link-attr[type="text"][name="text"]').val(s.text())}else i.find('input.fr-link-attr[type="text"]').val(""),i.find('input.fr-link-attr[type="checkbox"]').prop("checked",!1),i.find('input.fr-link-attr[type="text"][name="text"]').val(t.selection.text());i.find("input.fr-link-attr").trigger("change");var f=t.image?t.image.get():null;f?i.find('.fr-link-attr[name="text"]').parent().hide():i.find('.fr-link-attr[name="text"]').parent().show()}function f(){var n=t.$tb.find('.fr-command[data-cmd="insertLink"]'),i=t.popups.get("link.insert");if(i||(i=d()),!i.hasClass("fr-active"))if(t.popups.refresh("link.insert"),t.popups.setContainer("link.insert",t.$tb||e(t.opts.scrollableContainer)),n.is(":visible")){var r=n.offset().left+n.outerWidth()/2,a=n.offset().top+(t.opts.toolbarBottom?10:n.outerHeight()-10);t.popups.show("link.insert",r,a,n.outerHeight())}else t.position.forSelection(i),t.popups.show("link.insert")}function d(e){if(e)return t.popups.onRefresh("link.insert",p),t.popups.onHide("link.insert",o),!0;var i="";t.opts.linkInsertButtons.length>=1&&(i='<div class="fr-buttons">'+t.button.buildList(t.opts.linkInsertButtons)+"</div>");var r='<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="10" height="10" viewBox="0 0 32 32"><path d="M27 4l-15 15-7-7-5 5 12 12 20-20z" fill="#FFF"></path></svg>',a="",l=0;a='<div class="fr-link-insert-layer fr-layer fr-active" id="fr-link-insert-layer-'+t.id+'">',a+='<div class="fr-input-line"><input name="href" type="text" class="fr-link-attr" placeholder="URL" tabIndex="'+ ++l+'"></div>',t.opts.linkText&&(a+='<div class="fr-input-line"><input name="text" type="text" class="fr-link-attr" placeholder="'+t.language.translate("Text")+'" tabIndex="'+ ++l+'"></div>');for(var s in t.opts.linkAttributes)if(t.opts.linkAttributes.hasOwnProperty(s)){var f=t.opts.linkAttributes[s];a+='<div class="fr-input-line"><input name="'+s+'" type="text" class="fr-link-attr" placeholder="'+t.language.translate(f)+'" tabIndex="'+ ++l+'"></div>'}t.opts.linkAlwaysBlank||(a+='<div class="fr-checkbox-line"><span class="fr-checkbox"><input name="target" class="fr-link-attr" data-checked="_blank" type="checkbox" id="fr-link-target-'+t.id+'" tabIndex="'+ ++l+'"><span>'+r+'</span></span><label for="fr-link-target-'+t.id+'">'+t.language.translate("Open in new tab")+"</label></div>"),a+='<div class="fr-action-buttons"><button class="fr-command fr-submit" data-cmd="linkInsert" href="#" tabIndex="'+ ++l+'" type="button">'+t.language.translate("Insert")+"</button></div></div>";var d={buttons:i,input_layer:a},u=t.popups.create("link.insert",d);return t.$wp&&t.events.$on(t.$wp,"scroll.link-insert",function(){var e=t.image?t.image.get():null;e&&t.popups.isVisible("link.insert")&&E(),n&&t.popups.isVisible("link.insert")&&v()}),u}function u(){var i=n(),r=t.image?t.image.get():null;return t.events.trigger("link.beforeRemove",[i])===!1?!1:void(r&&i?(r.unwrap(),t.image.edit(r)):i&&(t.selection.save(),e(i).replaceWith(e(i).html()),t.selection.restore(),l()))}function c(){t.events.on("keyup",function(t){t.which!=e.FE.KEYCODE.ESC&&r(t)}),t.events.on("window.mouseup",r),t.helpers.isMobile()&&t.events.$on(t.$doc,"selectionchange",r),d(!0),"A"==t.$el.get(0).tagName&&t.$el.addClass("fr-view")}function k(n){var i,r,a=t.opts.linkList[n],l=t.popups.get("link.insert"),s=l.find('input.fr-link-attr[type="text"]'),o=l.find('input.fr-link-attr[type="checkbox"]');for(r=0;r<s.length;r++)i=e(s[r]),a[i.attr("name")]?i.val(a[i.attr("name")]):"text"!=i.attr("name")&&i.val("");for(r=0;r<o.length;r++)i=e(o[r]),i.prop("checked",i.data("checked")==a[i.attr("name")])}function g(){var n,i,r=t.popups.get("link.insert"),a=r.find('input.fr-link-attr[type="text"]'),l=r.find('input.fr-link-attr[type="checkbox"]'),s=a.filter('[name="href"]').val(),o=a.filter('[name="text"]').val(),p={};for(i=0;i<a.length;i++)n=e(a[i]),["href","text"].indexOf(n.attr("name"))<0&&(p[n.attr("name")]=n.val());for(i=0;i<l.length;i++)n=e(l[i]),n.is(":checked")?p[n.attr("name")]=n.data("checked"):p[n.attr("name")]=n.data("unchecked");var f=e(t.o_win).scrollTop();m(s,o,p),e(t.o_win).scrollTop(f)}function h(){if(!t.selection.isCollapsed()){t.selection.save();for(var n=t.$el.find(".fr-marker").addClass("fr-unprocessed").toArray();n.length;){var i=e(n.pop());i.removeClass("fr-unprocessed");var r=t.node.deepestParent(i.get(0));if(r){var a=i.get(0),l="",s="";do a=a.parentNode,t.node.isBlock(a)||(l+=t.node.closeTagString(a),s=t.node.openTagString(a)+s);while(a!=r);var o=t.node.openTagString(i.get(0))+i.html()+t.node.closeTagString(i.get(0));i.replaceWith('<span id="fr-break"></span>');var p=e(r).html();p=p.replace(/<span id="fr-break"><\/span>/g,l+o+s),e(r).html(p)}n=t.$el.find(".fr-marker.fr-unprocessed").toArray()}t.selection.restore()}}function m(a,l,s){"undefined"==typeof s&&(s={});var o=t.image?t.image.get():null;o||"A"==t.$el.get(0).tagName?"A"==t.$el.get(0).tagName&&t.$el.focus():(t.selection.restore(),t.popups.hide("link.insert"));var p=a;if(t.opts.linkConvertEmailAddress){var f=/^[\w._]+@[a-z\u00a1-\uffff0-9_-]+?\.[a-z\u00a1-\uffff0-9]{2,}$/i;f.test(a)&&!/^mailto:.*/i.test(a)&&(a="mailto:"+a)}if(""===t.opts.linkAutoPrefix||/^(mailto|tel|sms|notes|data):.*/i.test(a)||/^data:image.*/i.test(a)||/^(https?:|ftps?:|file:|)\/\//i.test(a)||["/","{","[","#","("].indexOf((a||"")[0])<0&&(a=t.opts.linkAutoPrefix+a),a=t.helpers.sanitizeURL(a),t.opts.linkAlwaysBlank&&(s.target="_blank"),t.opts.linkAlwaysNoFollow&&(s.rel="nofollow"),l=l||"",a===t.opts.linkAutoPrefix){var d=t.popups.get("link.insert");return d.find('input[name="href"]').addClass("fr-error"),t.events.trigger("link.bad",[p]),!1}var u,c=n();if(c){u=e(c);var k=t.node.rawAttributes(c);for(var g in k)k.hasOwnProperty(g)&&"class"!=g&&"style"!=g&&u.removeAttr(g);u.attr("href",a),l.length>0&&u.text()!=l&&!o&&u.text(l),o||u.prepend(e.FE.START_MARKER).append(e.FE.END_MARKER),u.attr(s),o||t.selection.restore()}else{o?o.wrap('<a href="'+a+'"></a>'):(t.format.remove("a"),t.selection.isCollapsed()?(l=0===l.length?p:l,t.html.insert('<a href="'+a+'">'+e.FE.START_MARKER+l+e.FE.END_MARKER+"</a>"),t.selection.restore()):l.length>0&&l!=t.selection.text().replace(/\n/g,"")?(t.selection.remove(),t.html.insert('<a href="'+a+'">'+e.FE.START_MARKER+l+e.FE.END_MARKER+"</a>"),t.selection.restore()):(h(),t.format.apply("a",{href:a})));for(var m=i(),v=0;v<m.length;v++)u=e(m[v]),u.attr(s),u.removeAttr("_moz_dirty");1==m.length&&t.$wp&&!o&&(e(m[0]).prepend(e.FE.START_MARKER).append(e.FE.END_MARKER),t.selection.restore())}if(o){var b=t.popups.get("link.insert");b.find("input:focus").blur(),t.image.edit(o)}else r()}function v(){l();var i=n();if(i){var r=t.popups.get("link.insert");r||(r=d()),t.popups.isVisible("link.insert")||(t.popups.refresh("link.insert"),t.selection.save(),t.helpers.isMobile()&&(t.events.disableBlur(),t.$el.blur(),t.events.enableBlur())),t.popups.setContainer("link.insert",e(t.opts.scrollableContainer));var a=(t.image?t.image.get():null)||e(i),s=a.offset().left+a.outerWidth()/2,o=a.offset().top+a.outerHeight();t.popups.show("link.insert",s,o,a.outerHeight())}}function b(){var e=t.image?t.image.get():null;if(e)t.image.back();else{t.events.disableBlur(),t.selection.restore(),t.events.enableBlur();var i=n();i&&t.$wp?(t.selection.restore(),l(),r()):"A"==t.$el.get(0).tagName?(t.$el.focus(),r()):(t.popups.hide("link.insert"),t.toolbar.showInline())}}function E(){var n=t.image?t.image.get():null;if(n){var i=t.popups.get("link.insert");i||(i=d()),p(!0),t.popups.setContainer("link.insert",e(t.opts.scrollableContainer));var r=n.offset().left+n.outerWidth()/2,a=n.offset().top+n.outerHeight();t.popups.show("link.insert",r,a,n.outerHeight())}}function y(i,a,l){"undefined"==typeof l&&(l=t.opts.linkMultipleStyles),"undefined"==typeof a&&(a=t.opts.linkStyles);var s=n();if(!s)return!1;if(!l){var o=Object.keys(a);o.splice(o.indexOf(i),1),e(s).removeClass(o.join(" "))}e(s).toggleClass(i),r()}return{_init:c,remove:u,showInsertPopup:f,usePredefined:k,insertCallback:g,insert:m,update:v,get:n,allSelected:i,back:b,imageLink:E,applyStyle:y}},e.FE.DefineIcon("insertLink",{NAME:"link"}),e.FE.RegisterShortcut(e.FE.KEYCODE.K,"insertLink",null,"K"),e.FE.RegisterCommand("insertLink",{title:"Insert Link",undo:!1,focus:!0,refreshOnCallback:!1,popup:!0,callback:function(){this.popups.isVisible("link.insert")?(this.$el.find(".fr-marker")&&(this.events.disableBlur(),this.selection.restore()),this.popups.hide("link.insert")):this.link.showInsertPopup()},plugin:"link"}),e.FE.DefineIcon("linkOpen",{NAME:"external-link"}),e.FE.RegisterCommand("linkOpen",{title:"Open Link",undo:!1,refresh:function(e){var t=this.link.get();t?e.removeClass("fr-hidden"):e.addClass("fr-hidden")},callback:function(){var e=this.link.get();e&&this.o_win.open(e.href)}}),e.FE.DefineIcon("linkEdit",{NAME:"edit"}),e.FE.RegisterCommand("linkEdit",{title:"Edit Link",undo:!1,refreshAfterCallback:!1,callback:function(){this.link.update()},refresh:function(e){var t=this.link.get();t?e.removeClass("fr-hidden"):e.addClass("fr-hidden")}}),e.FE.DefineIcon("linkRemove",{NAME:"unlink"}),e.FE.RegisterCommand("linkRemove",{title:"Unlink",callback:function(){this.link.remove()},refresh:function(e){var t=this.link.get();t?e.removeClass("fr-hidden"):e.addClass("fr-hidden")}}),e.FE.DefineIcon("linkBack",{NAME:"arrow-left"}),e.FE.RegisterCommand("linkBack",{title:"Back",undo:!1,focus:!1,back:!0,refreshAfterCallback:!1,callback:function(){this.link.back()},refresh:function(e){var t=this.link.get(),n=this.image?this.image.get():null;n||t||this.opts.toolbarInline?(e.removeClass("fr-hidden"),e.next(".fr-separator").removeClass("fr-hidden")):(e.addClass("fr-hidden"),e.next(".fr-separator").addClass("fr-hidden"))}}),e.FE.DefineIcon("linkList",{NAME:"search"}),e.FE.RegisterCommand("linkList",{title:"Choose Link",type:"dropdown",focus:!1,undo:!1,refreshAfterCallback:!1,html:function(){for(var e='<ul class="fr-dropdown-list">',t=this.opts.linkList,n=0;n<t.length;n++)e+='<li><a class="fr-command" data-cmd="linkList" data-param1="'+n+'">'+(t[n].displayText||t[n].text)+"</a></li>";return e+="</ul>"},callback:function(e,t){this.link.usePredefined(t)}}),e.FE.RegisterCommand("linkInsert",{focus:!1,refreshAfterCallback:!1,callback:function(){this.link.insertCallback()},refresh:function(e){var t=this.link.get();t?e.text(this.language.translate("Update")):e.text(this.language.translate("Insert"))}}),e.FE.DefineIcon("imageLink",{NAME:"link"}),e.FE.RegisterCommand("imageLink",{title:"Insert Link",undo:!1,focus:!1,callback:function(){this.link.imageLink()},refresh:function(e){var t,n=this.link.get();n?(t=e.prev(),t.hasClass("fr-separator")&&t.removeClass("fr-hidden"),e.addClass("fr-hidden")):(t=e.prev(),t.hasClass("fr-separator")&&t.addClass("fr-hidden"),e.removeClass("fr-hidden"))}}),e.FE.DefineIcon("linkStyle",{NAME:"magic"}),e.FE.RegisterCommand("linkStyle",{title:"Style",type:"dropdown",html:function(){var e='<ul class="fr-dropdown-list">',t=this.opts.linkStyles;for(var n in t)t.hasOwnProperty(n)&&(e+='<li><a class="fr-command" data-cmd="linkStyle" data-param1="'+n+'">'+this.language.translate(t[n])+"</a></li>");return e+="</ul>"},callback:function(e,t){this.link.applyStyle(t)},refreshOnShow:function(t,n){var i=this.link.get();if(i){var r=e(i);n.find(".fr-command").each(function(){var t=e(this).data("param1");e(this).toggleClass("fr-active",r.hasClass(t))})}}})});
(function(e,t){var n=e.amplitude||{};var r=t.createElement("script");r.type="text/javascript";
r.async=true;r.src="https://d24n15hnbwhuhn.cloudfront.net/libs/amplitude-2.9.0-min.gz.js";
r.onload=function(){e.amplitude.runQueuedFunctions()};var s=t.getElementsByTagName("script")[0];
s.parentNode.insertBefore(r,s);var i=function(){this._q=[];return this};function a(e){
i.prototype[e]=function(){this._q.push([e].concat(Array.prototype.slice.call(arguments,0)));
return this}}var o=["add","append","clearAll","set","setOnce","unset"];for(var c=0;c<o.length;c++){
a(o[c])}n.Identify=i;n._q=[];function u(e){n[e]=function(){n._q.push([e].concat(Array.prototype.slice.call(arguments,0)));
}}var l=["init","logEvent","logRevenue","setUserId","setUserProperties","setOptOut","setVersionName","setDomain","setDeviceId","setGlobalUserProperties","identify","clearUserProperties"];
for(var p=0;p<l.length;p++){u(l[p])}e.amplitude=n})(window,document);

amplitude.init("06d53f96731eb2c498a17703352ab0aa");
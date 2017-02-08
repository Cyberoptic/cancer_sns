$(document).bind('mobileinit',function(){
  $.mobile.page.prototype.options.keepNative = "select,input";
  $.mobile.ajaxEnabled = false;
});
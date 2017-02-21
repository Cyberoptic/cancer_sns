//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require prevent_mobile_init
//= require jquery.mobile
//= require foundation
//= require cable
//= require react
//= require react_ujs
//= require components
//= require cocoon
//= require_tree .

$(function(){ 
  $(document).foundation(); 
  $(".ui-loader").hide();
  
  $('.js-gallery-img').Am2_SimpleSlider();

  $.timeago.settings.strings = {
    prefixAgo: "",
    prefixFromNow: "今から",
    suffixAgo: "前",
    suffixFromNow: "後",
    seconds: "1分未満",
    minute: "約1分",
    minutes: "%d分",
    hour: "約1時間",
    hours: "約%d時間",
    day: "約1日",
    days: "約%d日",
    month: "約1月",
    months: "約%d月",
    year: "約1年",
    years: "約%d年",
    wordSeparator: ""
  };

  $('select[name="post[visibility]"]').on("change", function(){
    $('#new-post-dropdown').foundation('close');
  })

  $("input:file").on('change', function(){
    $("#js-file-count").text($(this)[0].files.length);
  });
});

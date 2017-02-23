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

  $("#post_images_upload").on('change', function(){
    $("#js-file-count").text($(this)[0].files.length);
  });

  $(".dropzone").dropzone({ 
    url: "/chat_rooms/" + $('.dropzone').data('chat-room-id') + "/messages",
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    init: function() {
      return this.on('success', function(file, json) {
        this.removeFile(file);
      });
    },
    dictDefaultMessage: '<i class="fa fa-file-o fa-2x"></i><br>\n<br>\nファイルをここにドロップするかここをクリックして下さい'
    });
});


function selectPhoto(e) {  
  if($(e)[0].files.length > 0) {
    $(e).parent().parent().find("label i").addClass("is-active")
  }
}
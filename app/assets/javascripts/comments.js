$(function() {
  $(".js-more_comments_button").on("click", function(){
  	var page = $(this).attr('data-page');
  	$.getScript("/posts/"+ this.id +"/more_comments?page="+page);
  });
});
 
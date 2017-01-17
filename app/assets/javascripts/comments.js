$(function() {
  $(".more_comments_button").on("click", function(){
  var more_posts_url = $('#post-'+ this.id +'-comments .pagination .next_page').attr('href');
  $.getScript(more_posts_url);
  });
});
 
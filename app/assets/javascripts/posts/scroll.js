$(document).ready(function() {
  if ($('#post-pagination .pagination').length) {
    $(window).scroll(function() {
      var url = $('#post-pagination .pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('#post-pagination .pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});

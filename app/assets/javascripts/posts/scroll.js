$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});


// $(document).ready(function () {
//   var isLoading = false;
//   if ($('#infinite-scrolling').size() > 0) {
//     $(window).on('scroll', function() {
//       var more_posts_url = $('.pagination a.next_page').attr('href');
//       if (!isLoading && more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
//         isLoading = true;
//         $.getScript(more_posts_url).done(function (data,textStatus,jqxhr) {
//           isLoading = false;
//         }).fail(function() {
//           isLoading = false;
//         });
//       }
//     });
//   }
// });
$(document).ready(function() {
  if ($('#post-pagination .pagination').length) {
    $(window).scroll(function() {
      var url = $('#post-pagination .pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $.getScript(url, function(){
          app.rebind();
          $('#posts').foundation(); 
        })

        return;
      }
    });    

    return $(window).scroll();    
  }
});

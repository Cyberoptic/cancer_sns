$(document).ready(function() {
  if ($('#post-pagination .pagination').length) {
    $(window).scroll(function() {
      var url = $('#post-pagination .pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $.getScript(url, function(){
          app.rebind();
          $('#posts').foundation(); 
          $('.sticky').foundation('_calc', true);          
        })

        return;
      }
    });    

    return $(window).scroll();    
  }
});

$(document).ready(function() {
  if ($('#messages-pagination .pagination').length) {
    $('#messages').scroll(function() {      
      var page = $(this).attr('data-page');
      var totalPages = parseInt($(this).attr('data-total-pages'));
      var chatRoomId = parseInt($(this).attr('data-chat-room-id'));      

      if ((page <= totalPages) && $('#messages').scrollTop() == 0) {                        
        $.getScript("/chat_rooms/"+ chatRoomId +"/load_more?page="+page);         
      }
    });
  }
});

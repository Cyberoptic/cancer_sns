$( function() {

  $('#notifications').on('click', function(element){
    element.preventDefault();
    // let id = $(element.target).data('id');

    $.ajax({
      url: "/notifications.json",
      // data: {i: id}   
    })
    .done(function(data){
      console.log(data);
  });

});
});
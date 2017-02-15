$(document).on('ready', function () {
  var messages, messages_to_bottom, form;
  messages = $('#messages');
  form = $('#new_message');

  if (messages.length > 0) {

    messages_to_bottom = function(){
      return messages.scrollTop(messages.prop('scrollHeight'));    
    };

    messages_to_bottom();

    App.global_chat = App.cable.subscriptions.create({
      channel: "ChatRoomsChannel",
      chat_room_id: messages.data('user-id')
    }, {
      connected: function () {
      },
      disconnected: function () {
      },
      received: function (data) {   
        console.log(data);

        if (messages.data('chat-room-id') === data['chat_room_id']) {
          messages.append(data['message']);  
        }
        
        // change sidebar snippet
        var $messageLi = $('li[data-chat-room-id="' + data['chat_room_id'] + '"]')
        var displayName;

        if (messages.data('user-id') === data['sender_id']){
          displayName = "あなた: "
        } else {
          displayName = ""
        }

        $messageLi.find(".js-last-message").text(displayName + data['message_snippet']);

        if (messages.data('user-id') !== data['sender_id'] && messages.data('chat-room-id') !== data['chat_room_id']) {
          $messageLi.find(".message-list-display-name").addClass("is-active");
          $messageLi.find(".js-last-message").addClass("bold");
          $messageLi.find(".js-last-message").removeClass("faded");
        }

        return messages_to_bottom();
      },
      send_message: function (message, chat_room_id) {
        return this.perform('send_message', {
          message: message,
          chat_room_id: chat_room_id
        });
      }
    });

    form.submit(function (e) {
      var textarea;
      textarea = $('#message_body');
      if ($.trim(textarea.val()).length > 1) {
        App.global_chat.send_message(textarea.val(), messages.data('chat-room-id'));
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });

    form.keypress(function(e){
      if(e.which == 13){
        $('#start-message').remove();
        $(this).closest('form').submit();   
        return false;
       }
    });
  }
});
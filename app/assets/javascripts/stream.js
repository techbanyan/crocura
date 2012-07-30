$(document).ready(function(){

  $('.load-more')
    .live("ajax:success", function(evt, data, status, xhr){
      $(xhr.responseText).appendTo('.get-more-stream');
      //$('.get-more-stream').animate({scrollTop: $('.get-more-stream').prop("scrollHeight")}, 500);
      $('.get-more-stream').scrollTop(1000);
    })
});
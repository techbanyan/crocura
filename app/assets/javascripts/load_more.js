$(document).ready(function(){
	
	$('.load-more')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      var $submitButton = $(this).find('input[name="commit"]');
	      $(this).text("LOADING ...");
	    })

		.live("ajax:success", function(evt, data, status, xhr){
			$(xhr.responseText).insertAfter($('.stream').last());
	      	$('html,body').animate({scrollTop: $('.stream').last().offset().top-200}, 1000);
	      	
	      	$(this).text("SHOW MORE");
	    })
});



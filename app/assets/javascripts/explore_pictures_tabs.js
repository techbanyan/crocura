$(document).ready(function(){
	
	$('.explore-pictures-tabs')

	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      // var $submitButton = $(this).find('input[name="commit"]');
	      // $(this).text("LOADING ...");
	      $(document).find(".stream-container").fadeOut(500);
	      $(document).find(".show-more-bar").fadeOut(500);
	      $(document).find(".loading-stream").show();



	    })

		.live("ajax:success", function(evt, data, status, xhr){
			$(document).find(".stream-container").replaceWith('<div class = "stream-container">' +(xhr.responseText)+ '</div>');
			$(document).find(".show-more-bar").fadeIn(1000);  
	      	$(document).find(".loading-stream").hide();   	
	    })
});
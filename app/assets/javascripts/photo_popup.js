$(document).ready(function(){

	$('.thumb-click-modal')
	    .live("ajax:beforeSend", function(evt, xhr, settings){

	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$.fancybox(this,{
				content: xhr.responseText,
			}); 
	    });
});
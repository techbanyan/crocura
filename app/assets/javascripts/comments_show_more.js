$(document).ready(function(){
	
	$('.comments-digest-show-all')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      $(this).text("Loading");
	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.comments-digest').replaceWith(xhr.responseText);
	    })
});
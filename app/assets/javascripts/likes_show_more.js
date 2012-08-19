$(document).ready(function(){
	
	$('.likes-digest-show-all')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      $(this).text("Loading");
	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.likes-digest').replaceWith(xhr.responseText);
	    })
});
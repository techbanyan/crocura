$(document).ready(function(){
	
	$('.like-icon')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	    	$(this).find('i').css("color","green");
	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.photo-box-likes-box').replaceWith(xhr.responseText);
	     	//var $submitButton = $(this).find('input[name="commit"]');
	      	//$submitButton.val( "Comment" );
	      	//$('.comment-text').val('');
	    })
});
$(document).ready(function(){
	
	// $('.unlike-icon').bind('mouseover', function() {
	//    $(this).text( $(this).text().replace('Liked','Unlike'));
	// })

	// $('.unlike-icon').bind('mouseout', function() {
	//    $(this).text( $(this).text().replace('Unlike','Liked'));
	// })

	$('.like-icon')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	    	$('.like-icon').text('Going');
	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.photo-box-likes-box').replaceWith(xhr.responseText);
	    })

	$('.unlike-icon')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	    	//$(this).text( $(this).text().replace('Unlike','Unliking'));
	    	$('.unlike-icon').text('Going');
	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.photo-box-likes-box').replaceWith(xhr.responseText);
	     	//var $submitButton = $(this).find('input[name="commit"]');
	      	//$submitButton.val( "Comment" );
	      	//$('.comment-text').val('');
	    })
});
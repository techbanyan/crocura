$(document).ready(function(){
	
	$('#create-comment-form')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      var $submitButton = $(this).find('input[name="commit"]');
	      $submitButton.val( "Going .." );

	    })

		.live("ajax:success", function(evt, data, status, xhr){
	      	$('.photo-box-comments-box').replaceWith(xhr.responseText);
	     	var $submitButton = $(this).find('input[name="commit"]');
	      	$submitButton.val( "Comment" );
	      	$('.comment-text').val('');
	    })
});
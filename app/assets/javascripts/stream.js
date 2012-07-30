$(document).ready(function(){

	$('.load-more')
	    .live("ajax:beforeSend", function(evt, xhr, settings){
	      //var $link = $(this).find('input[name="LOAD MORE"]');
	      //var $link = $(this).find('a[href$="LOAD MORE"]');
	      //alert($link.attr);

	      // Update the text of the submit button to let the user know stuff is happening.
	      // But first, store the original text of the submit button, so it can be restored when the request is finished.
	      //$link.data( 'origText', $(this).text() );
	      //$link.text( "LOADING..." );

	      $(this).hide();
	      $('.loading').show();

	    })

		.live("ajax:success", function(evt, data, status, xhr){
			$(xhr.responseText).appendTo('.get-more-stream');
	      	$(document.body).animate({scrollTop: $('.get-more-stream').children().last().offset().top-200}, 1500);
	      	$('.load-more').show();
	      	$('.loading').hide();
	    })
});
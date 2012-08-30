$(document).ready(function(){

	$('.unfollow-button').bind('mouseover', function() {
	   $('.unfollow-button').css('color', 'white');
	   $('.unfollow-button').text('Unfollow');
	})
	$('.unfollow-button').bind('mouseout', function() {
	   $('.unfollow-button').css('color', 'white');
	   $('.unfollow-button').text('Following');
	})

});
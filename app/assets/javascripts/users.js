$(document).ready(function(){

	$('.unfollow').bind('mouseover', function() {
	   $('.unfollow').css('color', 'white');
	   $('.unfollow').text('Unfollow');
	})
	$('.unfollow').bind('mouseout', function() {
	   $('.unfollow').css('color', 'black');
	   $('.unfollow').text('Following');
	})

});
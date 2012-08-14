$(document).ready(function(){
	
	$('.likes-digest-show-all').live('click', (function(){
		$('.likes-all').css("display", "inline");
		$('.likes-digest').replaceWith($('.likes-all'));
	}));

	$('.comments-digest-show-all').live('click', (function(){
		$('.comments-all').css("display", "inline");
		$('.comments-digest').replaceWith($('.comments-all'));
	}));
});
window.onload = function() {

	function toggler(element) {
		var target = element.firstElementChild.nextElementSibling;
		if (target.style.display == 'block') {
			target.style.display = 'none';
		} else {
			target.style.display = 'block';
		}
	}

	var movieTitles = document.getElementsByClassName("movie-container");
	for (var i = 0; i < movieTitles.length; i ++) {
		movieTitles[i].addEventListener('click', function() {
			toggler(this);
		}, false);
	}
}
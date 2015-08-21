# Movie Time

Movie Time is a Sinatra app created to serve as a tutorial for students learning basic web development. The app is a single page application that uses the omdbapi public api to allow users to make search queries for movie titles. User's can click on a search result to access additional information as well as mark a movie as a favorite, saving it on the backend to a persistent file storage. 

**STACK**
* Ruby 2.2.1
* Sinatra 1.4.6
* Basic HTML, CSS, and JavaScript (no jQuery)

**Functionality**
REQUEST | URL | DESCRIPTION
--- | --- | ---
GET | / | Renders home page with search functionality
POST | / | Post request to backend containing user's search query
GET | /favorites | Renders home page with a list of movie titles that have been saved as favorites
POST | /favorites | Post request to backend saving selected movie to a file storage for favorites

**Additional Tasks**
* Backend
	* Use OOP by creating a Movie object
		* Create instance methods for Movie to handle validation
	* Use OOP by creating a APIHandler object
		* Create a class method to handle the API call
	* Segregate MVC logic within the app.rb to promote seperation of concerns
	* Implement partials to help segregate templates from the index.erb for Search and Favorites
	* Replace file storage with an actual database(PostgreSQL)

* Front end
	* Overhaul the skeleton styling and emphasize UX/UI design. 
	* Include an AJAX call using a movie omdbID to generate even more info on click (full plot summary, rotten tomatoes review, etc).
	* Incorporate a front end MVC like backbone or anguler to replace the existing front end (handle templating, slugs/routing, ajax, animations, etc.)

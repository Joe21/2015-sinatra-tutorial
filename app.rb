require 'rubygems'
require 'sinatra'
require 'httparty'
require 'json'

# Get request to root path
get '/' do

  #######################################################
  # Objectives:
    # 1. Let's create a switch to control when to render favorites onto our index.erb
  #######################################################

  # Use this as a flag to prevent favorites from rendering. This is a precurser to yielding partial/multiple templates
  @show_favorites = false

  # Let's use an erb template to easily handle ruby logic instead of index.html which is limited to markdown
  erb :index
end

# Post request to root path (handles form submission)
post '/' do

  @show_favorites = false

  #######################################################
  # Objectives:
    # 1. Capture user's input and verify that it is parsed/normalized for ease of handling
    # 2. Test our omdbapi call with the users search param
    # 3. Capture omdbapi's response, once again verify the data.
    # 4. Send the desired data to the front end via an instance variable
  #######################################################

  # set a variable to capture the value from the form parameters
  search = params[:title]

  # [NOTE]: Once the request for the api endcall has been checked, you will notice it does not handle spaces
  # search = "star wars" vs search = "star+wars"
  # We need to parse our search variable to handle this by finding and replacing white spaces with +
  search.gsub!(/\s+/,'+')

  # set the request variable as a string for the api call. We can use string concatenation to dynamically input the search value
  request = "http://www.omdbapi.com/?s="+search+"&y=&plot=short&r=json"

  # set a response that will use HTTParty to send a get request to our api end point
  response = HTTParty.get(request)

  # Let's verify the data we are receiving back by using puts statements through our shell
  # This is a great habit to get into as you will always want to CONFIRM the type of data you are dealing with and how is it formatted, never assume
  # p "response is..."
  # p response
  # p "===================================="
  # p "response.class is..."
  # p response.class
  # p "===================================="
  # p "response['Search'] is..."
  # p response['Search']
  # p "===================================="
  # p "response['Search'].class is..."
  # p response['Search'].class
  # p "===================================="
  # p "response['Search'].length is..."
  # p response['Search'].length
  # p "===================================="

  # Let's access the hash containing an array of our results 
  @results = response['Search']

  erb :index
end

# Get request to /favorites
get '/favorites' do
  #######################################################
  # Objectives:
    # 1. Render favorites
    # 2. Access data from our file storage
    # 3. Parse/normalize the data so we can handle it with ease and uniformity
    # 4. Send the desired data to the front end via an instance variable
  #######################################################

  # Let's use a simple boolean to act as a flag to render the favorites section of our index.erb
  @show_favorites = true

  # Read our file storage
  file = File.read('data.json')

  # Verify the data!
  # p "================"
  # p "file is..."
  # p file
  # p file.class
  # p "================"

  # Parse the JSON string file into an array and set it to an instance variable using @
  @favorites = JSON.parse(file)

  # Verify the data!
  # p "================"
  # p "@favorites is..."
  # p @favorites
  # p @favorites.class
  # p "================"

  # render the index erb file for this action
  erb :index
end

# Post request to /favorites
post '/favorites' do
  #######################################################
  # OBJECTIVES:
  # 1) Take our data transmitted via post request and store it into a uniform hash
  # 2) Read our file storage
  # 3) Parse our file storage data
  # 4) Append our data into the file storage data
  # 5) Convert the appended data back to JSON and save!
  #######################################################

  # Our form is not handling ORM so we are getting back strings. Let's create a movie object to normalize
  # our data into a hash before saving it into our file storage.
  movie = {}
  movie[:title] = params[:title]
  movie[:oid] = params[:imdbID]

  # Refactored code below breakdown:
  # 1) Read our file used for storing our data
  # 2) Parse it into JSON string
  # 3) Afterwards, convert it to an array
  file = JSON.parse(File.read('data.json'))

  # Guess what time it is? Time to verify our data and the type
  # p "=============="
  # p "file is..."
  # p file
  # p file.class
  # p "=============="

  file = file.to_a

  # Use control flow to act as a basic form of validation to ensure our data is good and won't corrupt our file storage
  unless movie[:title] && movie[:oid]
    return 'Invalid Request'
  else 
    # Data's good to go, let's append into the file array and then rewrite our file storage
    file << movie
    File.write('data.json',JSON.pretty_generate(file))

    # Let's toss in a simple shell command to confirm this action 
    # p "============="
    # p "file written"
    # p "============="
  end

  redirect to('/favorites')
end
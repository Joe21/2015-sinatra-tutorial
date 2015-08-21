require 'sinatra'
require 'httparty'
require 'json'


# Get request to root path
get '/' do

  # Use this as a flag to prevent favorites from rendering unless chosen
  @show_favorites = false

  # Let's use an erb template to handle ruby logic instead of index.html which can only support markdown
  erb :index
end

# Post request to root path (handles form submission)
post '/' do

  # set a variable to capture the value from the from the form params
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
  # It's a good habit to always CONFIRM the type of data you are dealing with and how is it formatted, never assume
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

  @results = response['Search']

  erb :index
end

# Get request to /favorites
get '/favorites' do

  @show_favorites = true

  file = File.read('data.json')
  @favorites = JSON.parse(file)

  p "================"
  p "@favorites is..."
  p @favorites
  p @favorites.class
  p "================"

  erb :index
end

post '/favorites' do

  # OBJECTIVES:
  # 1) Take our data transmitted via post request and store it into a uniform hash
  #   a) 




  # Our form is not handling ORM so we are returning back strings. Let's create a movie object to normalize
  # our data into a has before saving it into our file storage.
  movie = {}
  movie[:title] = params[:title]
  movie[:oid] = params[:imdbID]

  # Refactored code below breakdown:
  # 1) Read our file used for storing our data
  # 2) Parse it into JSON string
  # 3) Convert it to an array
  file = JSON.parse(File.read('data.json'))

  p "=============="
  p "json parse..."
  p file
  p "=============="

  file = file.to_a

  # Use control flow to act as a basic form of validation to ensure our data is good and won't corrupt our file storage
  unless movie[:title] && movie[:oid]
    return 'Invalid Request'
  else 

    movie
    file << movie
    File.write('data.json',JSON.pretty_generate(file))
    p "============="
    p "file written"
    p "============="
  end


  # new_favorite.to_json
  # file << new_favorite
  # File.open('data.json','w') do |f|
  #   f.puts JSON.pretty_generate(file)
  # end
  # File.write('data.json',JSON.pretty_generate(file))

  erb :index
end
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
  data_hash = JSON.parse(file)

  # p "===================="
  # p data_hash
  # p data_hash.class
  # p "===================="
  @favorites = []

  erb :index
end

post '/favorites' do
  movie = params[:movie]

  file = JSON.parse(File.read('data.json'))
  unless movie["Title"] && movie["imdbID"]
    return 'Invalid Request'
  end

  new_favorite = {name: movie["Title"], oid: movie["imdbID"]}
  # new_favorite.to_json
  # file << new_favorite
  # File.open('data.json','w') do |f|
  #   f.puts JSON.pretty_generate(file)
  # end
  # File.write('data.json',JSON.pretty_generate(file))

  erb :index
end
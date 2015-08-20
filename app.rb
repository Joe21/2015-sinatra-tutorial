require 'sinatra'
require 'httparty'


# Get request to root path
get '/' do

  # Let's use an erb template to handle ruby logic instead of index.html which can only support markdown
  erb :index
end

# Post request to root path (handles form submission)
post '/' do

  # set a variable to capture the value from the from the form params
  search = params[:title]

  # [NOTE]: Once the request for the api endcall has been checked, you will notice it does not handle spaces
  # search = "star wars" vs search = "star+wars"
  # We need to parse our search variable to handle this properly by finding and replacing white spaces with +
  search.gsub!(/\s+/,'+')

  # set the request variable as a string for the api call. We can use string concatenation to dynamically input the search value
  request = "http://www.omdbapi.com/?s="+search+"&y=&plot=short&r=json"

  # set a response that will use HTTParty to send a get request to our api end point
  response = HTTParty.get(request)

  # Let's verify the data we are receiving back by using puts statements through our shell
  # It's a good habit to always CONFIRM the type of data you are dealing with and how is it formatted rather than assume it
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
  Response.header['Content-Type'] = 'application/json'
  File.read('data.json')
end

post '/favorites' do
  file = JSON.parse(File.read('data.json'))
  unless params[:name] && params[:oid]
    return 'Invalid Request'
  end
  movie = { name: params[:name], oid: params[:oid] }
  file << movie
  File.write('data.json',JSON.pretty_generate(file))
  movie.to_json
end
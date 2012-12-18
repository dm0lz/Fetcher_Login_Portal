require 'sinatra/base'
require 'mongo'
require 'pry'
require 'haml'
require 'sass'
require 'rack-flash'
require 'fetcher-mongoid-models'

Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/fetcher-mongoid-models/config/main.yml"

class MongoInterface < Sinatra::Base

set :haml, :format => :html5
set :port, 4568
use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
use Rack::Flash
#enable :sessions

	get '/style.css' do
		sass :style
	end

	get '/' do
	  @flash = flash[:notice]
	  haml :index
	  #binding.pry
	end

	post '/resultat' do
	  session[:filter] = params[:filter]
	  session[:streamType] = params[:streamType]
	  session[:streamArgument] = params[:streamArgument]
	  session[:login] = params[:login]
	  session[:viewer] = params[:viewer]
	  session[:column_object_id] = params[:column_object_id]
	  
	  redirect '/resultat'
	end

	get '/resultat' do
		
	  filter = session[:filter] 
	  streamType = session[:streamType]
	  streamArgument = session[:streamArgument].split
	  login = session[:login] 
	  
	 #to_insert_to_columns = { 
	 #"filter"=>
	 # [{"type"=>"text",
	 #   "property"=>"articleBody",
	 #   "operator"=>"includes",
	 #   "value"=>[filter]}],
	 #"source"=>
	 # [{"streamType"=> streamType,
	 #   "streamArgument"=> streamArgument,
	 #   "provider"=>"twitter",
	 #   "endpoint"=> streamType,
	 #   "viewer"=> session['id'] }] 
	 # }
	  #to_insert_to_source = {
	  #	"streamType"=> streamType,
	  #  "streamArgument"=> streamArgument,
	  #  "provider"=>"twitter",
	  #  "endpoint"=> streamType,
	  #  "viewer"=> session['id'] 
	  #}

	  column = Column.new(
		  "filter"=>
		  [{"type"=>"text",
		    "property"=>"articleBody",
		    "operator"=>"includes",
		    "value"=>[filter]}],
		 "source"=>
		  [{"streamType"=> streamType,
		    "streamArgument"=> streamArgument,
		    "provider"=>"twitter",
		    "endpoint"=> streamType,
		    "viewer"=> session['id'] }] 
	  )


	  source = Source.new(
	  	"streamType"=> streamType,
	    "streamArgument"=> streamArgument,
	    "provider"=>"twitter",
	    "endpoint"=> streamType,
	    "viewer"=> session['id'] 
	  )


	  begin
	  	#user_id_to_update = usersCollection.find({"login" => session["register_username"]}).find.each{|i| p i}['_id']
	  	user_id_to_update = User.where(login: session["register_username"]).first.attributes["_id"]
	  rescue Exception => e
	  	puts "the user you want to add columns to couldn't be found. Here is the error message : #{e.message}"
	  end


	  unless session[:column_object_id].empty?
	  	#binding.pry
	  	Column.where(_id: session[:column_object_id]).push(:source, source.attributes)
	  	User.where(_id: user_id_to_update).push(:column, session[:column_object_id])
	  	#columnsCollection.update( { "_id" => BSON::ObjectId(session[:column_object_id]) }, { "$push" => { "source" => to_insert_to_source } } )
			#usersCollection.update( {"_id" => user_id_to_update }, {"$set" => { "columns" => BSON::ObjectId(session[:column_object_id]) } } )
	  else
	  	column.save
	  	column_id = column.attributes["_id"]
	  	User.where(_id: user_id_to_update).push(:column, column_id)
	  	#column_id = columnsCollection.insert(to_insert_to_columns)
			#usersCollection.update( {"_id" => user_id_to_update }, {"$push" => {"columns" => column_id }} )
	  end

		flash[:notice] = "Here is the user_id from users collection to be inserted in shore : #{user_id_to_update} and here is the column_id you can use to add more sources : #{column_id}"

	  #binding.pry
	  redirect '/'
	end

helpers do
	def client
		@client ||= Mongo::Connection.new("mongocfg1.fetcher")
	end
	def db
		db ||= client['test']
	end
	def columnsCollection
		coll ||= db['columns']
	end
	def usersCollection
		coll ||= db['users']
	end
end

end
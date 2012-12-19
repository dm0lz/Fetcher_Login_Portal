require 'sinatra/base'
require 'mongo'
require 'pry'
require 'haml'
require 'sass'
require 'rack-flash'
require 'fetcher-mongoid-models'

Fetcher::Mongoid::Models::Db.new "../config/main.yml"

class MongoInterface < Sinatra::Base

set :haml, :format => :html5
set :port, 4568

use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
use Rack::Flash

	get '/style.css' do
		sass :style
	end

	get '/' do
	  @flash = flash[:notice]
	  haml :index
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

	  streamType = session[:streamType]
	  streamArgument = session[:streamArgument].split
	  login = session[:login] 
	  
	  column = Column.new

	  source = Source.new(
	  	"streamType"=> streamType,
	    "streamArgument"=> streamArgument,
	    "provider"=>"twitter",
	    "endpoint"=> streamType,
	    "viewer"=> session['id'] 
	  )

	  filter = Filter.new(
			"type" =>"text",
	    "property" =>"articleBody",
	    "operator" =>"includes",
	   	"value" =>[session[:filter]]
	  )

	  begin
	  	user_id_to_update = User.where(login: session["register_username"]).first._id
	  rescue Exception => e
	  	puts "the user you want to add columns to couldn't be found. Here is the error message : #{e.message}"
	  end

	  unless session[:column_object_id].empty?
	  	source.save
	  	filter.save
	  	Column.where(_id: session[:column_object_id]).push(:Source, source._id)
	  	Column.where(_id: session[:column_object_id]).push(:Filter, filter._id)	
	  else
	  	source.save
	  	filter.save
	  	column.Filter.push filter._id
	  	column.Source.push source._id
	  	column.save
	  	User.where(_id: user_id_to_update).push(:Column, column._id)
	  end

		flash[:notice] = "Here is the user_id from users collection to be inserted in shore : #{user_id_to_update}"

	  redirect '/'
	end


end
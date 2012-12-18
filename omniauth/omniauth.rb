require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'pry'
require 'haml'
require 'mongo'
require 'g11n'
require 'fetcher-mongoid-models'

SCOPE = 'email,read_stream,publish_stream,manage_pages'

unless File.exists? "config/config.yaml"
  puts "config/config.yaml is missing"
  Process.exit
else
  CONFIG = SymbolMatrix.new "config/config.yaml"
end

Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/fetcher-mongoid-models/config/main.yml"

class OmniauthConnect < Sinatra::Base
  
  set :haml, :format => :html5 
  set :protection, :except => :frame_options
  #enable :sessions

  use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
  #use Rack::Flash
  use OmniAuth::Builder do
    #provider :facebook, CONFIG.facebook_app_id, CONFIG.facebook_app_secret, {:scope => SCOPE, :redirect_uri => "https://fetcher.xaviervia.com.ar:8005/", :display => 'popup' ,:client_options => {:ssl => {:ca_path => "config/cert.crt"}}}
    provider :twitter, CONFIG.twitter_consumer_key, CONFIG.twitter_consumer_secret
  end

  

  #configure :production do
  #  use Rack::SslEnforcer
  #end
  
  #post '/' do
  #  redirect 'https:///'
  #end


  

  get '/' do
    if session['access_token']
      @gold_token = session['access_token']
      @name = session['name']
      @foto = session['picture']
      @ciudad = session['location']
      @email = session['email']
      @provider = session['provider']
      @item_id = session['id']
      #OmniAuth.config.full_host = "https://fetcher.xaviervia.com.ar:8005" #if session['provider'] == "facebook"
        
      #binding.pry
      haml :index
    else
      #binding.pry
      haml :login_page
    end
  end

  get '/logout' do
    session['access_token'] = nil
    session['access_secret'] = nil
  end

  get '/auth/:provider/callback' do    

    session['access_token'] = request.env['omniauth.auth']['credentials'].token
    session['access_secret'] = request.env['omniauth.auth']['credentials'].secret
    session['name'] = request.env['omniauth.auth']['info'].name
    session['location'] = request.env['omniauth.auth']['info'].location
    session['picture'] = request.env['omniauth.auth']['info'].image
    session['email'] = request.env['omniauth.auth']['info'].email
    session['provider'] = request.env['omniauth.auth'].provider
    #OmniAuth.config.full_host = "https://fetcher.xaviervia.com.ar:8005" #if session['provider'] == "facebook"
    session['id'] = request.env['omniauth.auth']['uid'].to_i
    session['description'] = request.env['omniauth.auth']['extra']['raw_info']['description'] if session['provider'] == "twitter"
    session['description'] = request.env['omniauth.auth']['extra']['raw_info']['work'] if session['provider'] == "facebook"
    session['time'] = Time.parse(request.env['omniauth.auth']['extra']['raw_info']['created_at']).to_i if session['provider'] == "twitter"
    session['time'] = request.env['omniauth.auth']['extra']['raw_info']['created_at'] if session['provider'] == "facebook"
    session['url'] = "https://twitter.com/" +request.env['omniauth.auth']['extra']['raw_info']['screen_name'] if session['provider'] == "twitter"
    session['url'] = "http://facebook.com/" + request.env['omniauth.auth']['extra']['raw_info']['username'] if session['provider'] == "facebook"

  
    #  to_be_inserted_in_person_user = { 
    #  "provider" => [session['provider']],
    #  "additionalType" => [ "http://getfetcher.net/Item" ], 
    #  "Item#id" => [ session['id'] ], 
    #  "name" => [session['name']], 
    #  "User#dateRegistered" => [ session['time'] ], 
    #  "description" => [ session['description'] ], 
    #  "url" => [ session['url'] ], 
    #  "accessToken" => session['access_token'], 
    #  "accessSecret" => session['access_secret'] 
    #}

    personuser = PersonUser.new(
      "provider" => [session['provider']],
      "additionalType" => [ "http://getfetcher.net/Item" ], 
      "itemId" => [ session['id'] ], 
      "name" => [session['name']], 
      "userDateRegistered" => [ session['time'] ], 
      "description" => [ session['description'] ], 
      "url" => [ session['url'] ], 
      "accessToken" => session['access_token'], 
      "accessSecret" => session['access_secret']
      )

      if not_in_db? session['id']
        #person_User_Collection.insert to_be_inserted_in_person_user
        personuser.save
      end

    #redirect 'https:///'
    redirect '/'
  end

  get '/auth/failure' do
    'You Must Allow the application to access your data !!!'
  end

  helpers do

    def not_in_db? uid
      #person_User_Collection.find( "Item#id" => uid ).to_a.empty?
      not PersonUser.where(itemId: uid).exists?
    end    
    #def client
    #  @client ||= Mongo::Connection.new("mongocfg1.fetcher")
    #end
    #def db
    #  db ||= client['test']
    #end  
    #def person_User_Collection
    #  coll ||= db['http://schema.org/Person/User']
    #end
  end

end








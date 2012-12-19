require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'pry'
require 'haml'
require 'mongo'
require 'g11n'
require 'fetcher-mongoid-models'

Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/fetcher-mongoid-models/config/main.yml"

unless File.exists? "config/config.yaml"
  puts "config/config.yaml is missing"
  Process.exit
else
  CONFIG = SymbolMatrix.new "config/config.yaml"
end

class OmniauthConnect < Sinatra::Base
  
  set :haml, :format => :html5 
  set :protection, :except => :frame_options
  set :port, 4567

  use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
  
  use OmniAuth::Builder do
    provider :twitter, CONFIG.twitter_consumer_key, CONFIG.twitter_consumer_secret
  end

  get '/' do
    if session['access_token']
      @gold_token = session['access_token']
      @name = session['name']
      @foto = session['picture']
      @ciudad = session['location']
      @email = session['email']
      @provider = session['provider']
      @item_id = session['id']
      #binding.pry
      haml :index
    else
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
    session['id'] = request.env['omniauth.auth']['uid'].to_i
    session['description'] = request.env['omniauth.auth']['extra']['raw_info']['description'] if session['provider'] == "twitter"
    session['time'] = Time.parse(request.env['omniauth.auth']['extra']['raw_info']['created_at']).to_i
    session['url'] = "https://twitter.com/" +request.env['omniauth.auth']['extra']['raw_info']['screen_name']

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
        personuser.save
        user_id_to_update = User.where(login: session["register_username"]).first._id
        User.where(_id: user_id_to_update).push(:PersonUser, personuser._id)
      end

    redirect '/'
  end

  get '/auth/failure' do
    'You Must Allow the application to access your data !!!'
  end

  helpers do
    def not_in_db? uid
      not PersonUser.where(itemId: uid).exists?
    end    
  end

end








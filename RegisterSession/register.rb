require "sinatra/base"
require "pry"
require "mongo"
require "json"
require "symbolmatrix"
require "haml"
require "rack/flash"
require "fetcher-mongoid-models"

Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/fetcher-mongoid-models/config/main.yml"

class Register < Sinatra::Base

set :haml, :format => :html5
set :port, 4566

use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
use Rack::Flash


  get '/' do
    redirect '/register'
  end

  get '/register' do
    @flash = flash[:notice]
    haml :index
  end

  post '/resultat' do
    session[:register_username] = params[:inputUsername]
    session[:register_email] = params[:inputEmail]
    session[:register_password] = params[:inputPassword]
    session[:register_inputPasswordConfirm] = params[:inputPasswordConfirm]
    session[:register_session_id] = env['rack.session']['session_id']

    user = User.new("login" => session[:register_username], "email" => session[:register_email], "password" => session[:register_password])
    session[:register_mongo_id] = user.attributes["_id"]
    
    if session[:register_password] == session[:register_inputPasswordConfirm] && not_in_db? && password_not_nil?
      #binding.pry
      user.save
      redirect '/resultat'
    else
      #binding.pry
      flash[:notice] = "error !! password doesnt match or email is already_in_db or password is blank !!"
      redirect '/register'
    end
  end

  get '/resultat' do

    @username = session[:register_username]
    @email = session[:register_email]
    @password = session[:register_password]
    @passwordConfirm = session[:register_inputPasswordConfirm]
    
    @set = User.find(session[:register_mongo_id])
    @parsedTest = @set.attributes

    haml :resultat
    #binding.pry
  end

helpers do
  def not_in_db?
    not User.where(email: session[:register_email]).exists?
  end
  def password_not_nil?
    not session[:register_password].empty?
  end
end


end

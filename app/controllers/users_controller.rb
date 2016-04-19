require './config/environment'
require 'pry'

class UsersController < ApplicationController
#Home
  get '/' do 
  	erb :'index'
  end


#Sign Up
  get '/signup' do
  	if Helpers.is_logged_in?(session)
  		redirect '/home'
  	else
  		erb :'users/signup', :locals => {:message => 'message'}
  	end
  end

  post '/signup' do 
    if params[:username] == 'Username' || params[:password] == 'password'
       erb :'users/signup', :locals => {:message => 'error'}
    elsif User.find_by(:username => params[:username])
      erb :'users/signup', :locals => {:message => 'same'}
    elsif params[:username].empty? || params[:password].empty?
      erb :'users/signup', :locals => {:message => 'empty'}
    else
    	@user = User.create(:username => params[:username], :password => params[:password])
    	@user.save
    	session[:id] = @user[:id]
      if @user.save
        redirect '/home'
      else
  		  erb :'users/signup', :locals => {:message => 'message'}
      end
  	end
  end

#Log in
  get '/login' do
  	if Helpers.is_logged_in?(session)
  		redirect '/home'
  	else
		erb :'users/login', :locals => {:message => 'message'}
	end
  end

  post '/login' do 
 	@user = User.find_by(:username => params[:username])
 	  if @user && @user.authenticate(params[:password])
  		session[:id] = @user[:id]
		  redirect '/home'
	  else
		  erb :'users/login', locals: {message:"error"}
	  end
  end

  #Log Out
  get '/logout' do 
  	session.clear
  	erb :'users/login', :locals => {:message => 'success'}
  end

  #Home Page - shows user lists
  get '/home' do
  	if Helpers.is_logged_in?(session)
  		@user = User.find_by_id(session[:id])
  		erb :'users/home'
  	else
  		redirect '/login'
  	end
  end

  #Show single users lists
  get '/users/:slug' do 
  	@user = User.find_by_slug(params[:slug])
  	erb :'users/home'
  end

end

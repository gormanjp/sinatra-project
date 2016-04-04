require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
  	set :session_secret, "secret"
  end


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

  #LISTS
  #New List
  get '/lists/new' do 
  	if Helpers.is_logged_in?(session)
	  	@user = User.find_by_id(session[:id])
  		erb :'lists/new', :locals => {:message => 'message'}
  	else
  		redirect '/login'
  	end
  end

  post '/lists/new' do 
  	if !params[:name].empty?
  		@list = List.create(:name => params[:name])
  		@user = User.find_by_id(session[:id])
  		@user.lists << @list
  		redirect "/lists/#{@list.id}"
  	else
  		erb :'lists/new', :locals => {:message => 'error'}
  	end
  end	

  #Show List
  get '/lists/:id' do
  	if Helpers.is_logged_in?(session)
  		@list = List.find_by(:id => params[:id])
  		 erb :'lists/show'
  	else
  		redirect '/login'
  	end
  end

  post '/lists/items/:id' do 
    @item = Item.find(params[:id])
    @list = List.find(@item.list_id)
    i = 0 
    params.each do |k,v|
      if v == "on"
        i += 1
      end
    end
    @item.checks = i
    @item.save
    erb :'lists/show'
  end

  #Edit List
  get '/lists/:id/edit' do 
  	if Helpers.is_logged_in?(session)
  		@list = List.find_by(:id => params[:id])
  		erb :'lists/edit'
  	else
  		redirect '/login'
  	end
  end

  patch '/lists/:id/edit' do
  	@list = List.find_by(:id => params[:id])
    @user = User.find_by_id(session[:id])
    redirect "/home" if @user.id != @list.user_id
  	if params[:name] != ""
  		@list.name = params[:name]
  		@list.save
  		redirect "/lists/#{@list.id}"
  	else
  		erb :'lists/edit'
  	end
  end

  #Delete List
  delete '/lists/:id/delete' do 
  	@user = User.find_by_id(session[:id])
  	@list = List.find_by(:id => params[:id])
  	List.delete(params[:id]) if @user.id == @list.user_id
  	redirect '/home'
  end

#ITEMS
  #new item
  get '/items/:id/new' do 
   if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:id])
      @list = List.find_by(:id => params[:id])
      erb :'items/new', :locals => {:message => 'message'}
    else
      redirect '/login'
    end
  end

  post '/items/:id/new' do 
    if params[:content] != "" && params[:frequency] != 0
      @list = List.find_by(:id => params[:id])
      @item = Item.create(:content => params[:content], :frequency => params[:frequency], :checks => 0)
      @list.items << @item
      redirect "/lists/#{@list.id}"
    else
      @user = User.find_by_id(session[:id])
      @list = List.find_by(:id => params[:id])
      erb :'items/new', :locals => {:message => 'error'}
    end
  end

end

























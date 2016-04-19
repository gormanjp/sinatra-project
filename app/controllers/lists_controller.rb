require './config/environment'
require 'pry'

class ListsController < ApplicationController

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
    @list = List.find_by(:id => params[:id]) 
  	if Helpers.is_logged_in?(session) && Helpers.user_match(@list,session)
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
    @list = List.find_by(:id => params[:id])
  	if Helpers.is_logged_in?(session) && Helpers.user_match(@list,session)
  		erb :'lists/edit'
  	else
  		redirect '/login'
  	end
  end

  patch '/lists/:id/edit' do
    @list = List.find_by(:id => params[:id])
  	if !params[:name].empty?
  		@list.name = params[:name]
  		@list.save
  		redirect "/lists/#{@list.id}"
  	else
  		erb :'lists/edit', :locals => {:message => 'error'}
  	end
  end

  #Delete List
  delete '/lists/:id/delete' do 
  	@list = List.find_by(:id => params[:id])
    List.delete(params[:id])if Helpers.is_logged_in?(session) && Helpers.user_match(@list,session)
  	redirect '/home'
  end

end
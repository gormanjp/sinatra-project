require './config/environment'
require 'pry'

class ItemsController < ApplicationController


#ITEMS
  #new item
  get '/items/:id/new' do 
  @list = List.find_by(:id => params[:id])
   if Helpers.is_logged_in?(session) && Helpers.user_match(@list,session)
      @user = User.find_by_id(session[:id])
      erb :'items/new', :locals => {:message => 'message'}
    else
      redirect '/login'
    end
  end

  post '/items/:id/new' do 
    if params[:content] != "" && !params[:frequency].empty?
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
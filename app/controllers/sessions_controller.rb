class SessionsController < ApplicationController
  def new
  end

  def create
    username = params[:session][:username]
    password = params[:session][:password]

    user = User.find_by username: username
    
    if !user.nil? && user.authenticate(password)
      puts "successful login"
      log_in user
      redirect_to "/users/#{username}"
    else
      # flash[]
      redirect_to '/login'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  
  
end

class LoginController < ApplicationController
  def index
  end
  
  def login
    # parse params, get username and password
    input_login = login_params
    input_username = input_login[:username]
    input_password = input_login[:password]



    # find user in db using username
    user = User.find_by(username: input_username)
    if user == nil
      #render "The username is not corrected"
      redirect_to "/login"
    else
      salt = user[:salt]
      input_encrypted_password = BCrypt::Engine.hash_secret(input_password, salt)
      real_encrypted_password = user[:encrypted_password]
    
      if input_encrypted_password == real_encrypted_password && 
         input_username == user[:username] 
      
        show_user_url = "/users/#{user[:username]}";
        print "show: {#show_user_url}"
        redirect_to show_user_url
      end
     end 

  end
  
  private
  def login_params
    params.require(:user).permit(:username, :password)
  end

end

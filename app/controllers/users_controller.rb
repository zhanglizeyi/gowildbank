require 'bcrypt'
class UsersController < ApplicationController
  http_basic_authenticate_with name: "zzz", password: "1234"
  
  def validate(record)
    if record.username = nil
      record.error[:base] << "This is null"
    end
  end

  def new
    @user = User.new 
  end

  def create
    input_user = user_params
    password = input_user[:password]
    password_confirmation = input_user[:password_confirmation]
    
    #if password != password_confirmation
    # Report error to user and return
    #end

    # user_data is a object with fields: username, email, salt, encrypted_password
    user_data = {}
    user_data[:username] = input_user[:username]
    user_data[:email] = input_user[:email]
    user_data[:salt] = BCrypt::Engine.generate_salt
    user_data[:encrypted_password] = BCrypt::Engine.hash_secret(password, user_data[:salt])
    
    #user_data[:debit] = 0.0
    #user_data[:credit] = 0.0
    
    @user = User.new(user_data)

    if @user.save
      flash.notice = "you signed up successfully"
      flash.notice = "valid"
      print "save success"
      redirect_to("/login")
    #render 'new'
    else
      flash.notice = "invalid"
      #render 'new'
      print "save fails"
      redirect_to("/login")
    end
  end
  
  def show
    # find user by user name
    print "show params: #{params}"
    
    #@user = User.find(params[:username])
    
    @user = User.find_by username: params[:username]

    print "show user: #{@user}"
    print "username: #{@user.username}"
    
    # render user profile based on user object
  end

  def edit
    @user = User.find_by username: params[:username]
  end

  def update
    user = User.find_by username: params[:username]

    print "user = #{user}"
    
    if user == nil
      # report error
    end

    # update user data in db
    user_input_data = get_update_balance_params
    
    input_debit = user_input_data[:debit]
    input_credit = user_input_data[:credit] #not use

    user.debit = input_debit
    user.credit = input_credit

    if !user.save
      # save to db not success, report error to user
      flash[:notice] = "Can't create new user, try again"
      print "save db failed"
      # redirect_to "/users/new"
    end
    
    @user = user
    redirect_to "/users/#{@user.username}"
  end

  def create_bank_account
    input_account_params = create_account_params
    account_type = input_account_params[:account_type]
    label = input_account_params[:label]
    username = input_account_params[:username]

    user = User.find_by username: username
    if !user
      # report error says user not found, can not create account
      render inline: "No such user!!!"
      return
    end

    bank_account_data = {}
    bank_account_data[:account_type] = account_type
    bank_account_data[:balance] = 0.0
    bank_account_data[:label] = label
    bank_account_data[:user_id] = user.id
    @bank_account = BankAccount.new(bank_account_data)

    if @bank_account.save
      print "created bank_account of type #{@bank_account.account_type}\n."
    else
      print "fail to create bank_account of type #{@bank_account.account_type}\n."
    end
    redirect_to("/users/#{user.username}")
   
    # input_params = create_account_params
    # user = User.find_by username: input_params[:username]
    # @user = user
    # print "user is #{user}"

    # redirect_to "/users/#{@user.username}"
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def get_update_balance_params
    params.require(:user).permit(:debit, :credit)
  end

  def create_account_params
    result = {
      :username => params[:username],
      :account_type => params[:account][:account_type],
      :label => params[:account][:label]
    }
  end

end
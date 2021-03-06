require 'bcrypt'
class UsersController < ApplicationController
  #http_basic_authenticate_with name: "zzz", password: "1234"
  
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
    user_data = {}
    user_data[:username] = input_user[:username]
    user_data[:email] = input_user[:email]
    user_data[:password] = input_user[:password]
    user_data[:password_confirmation] = input_user[:password_confirmation]

    user_exist =  User.find_by username: params[:username]
    print "user============================> #{user_exist}"

    if user_exist != nil
      render inline: "user #{user_exist} is already in db"
      return
    end

    new_user = User.new(user_data)

    if new_user.save
      @user = new_user
      print "save success"
      redirect_to("/login")
    else
      render inline: "create user failed"
      return
    end

  end
  
  def show
    
    if !logged_in?
      render inline: "only logged in user can see the infomation "
      return
    end
    
    if current_user.username != params[:username]
      render inline: "user can only see self"
      return
    end

    # find user by user name
    print "show params: #{params}"
    
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
    #label = input_account_params[:label]
    label = rand(13900000000 .. 13999999999).to_s
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

    label = create_account_params[:label]
    label_exist = user.bank_accounts.find_by label: label

    print "label_exist ==========================> #{label_exist}"

    #change the multiple label and nil label
    if !label_exist && label != ""
      @bank_account.save
      redirect_to("/users/#{user.username}")
      print "created bank_account of type #{@bank_account.account_type}\n."
    else
      render inline: "Duplicate label OR empty Label!!!!"
      print "fail to create bank_account of type #{@bank_account.account_type}\n."
    end
  
  end

  def delete_bank_account
    input_params = delete_account_params
    username = input_params[:username]

    user = User.find_by username: username
    if !user
      render inline: "user with name #{username} is not found!!"
      return
    end

    print "input: #{input_params}"
    print "user #{user}"

    label = input_params[:account_label]

    print "label #{label}"

    bank_account_to_be_deleted = user.bank_accounts.find_by label: label
    
    if !bank_account_to_be_deleted
      render inline: "account with label #{label} is not found!!"
      return
    end

    user.bank_accounts.destroy(bank_account_to_be_deleted.id)
    
    redirect_to '/users/#{username}'
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

  def delete_account_params
    result = {
      :username => params[:username],
      :account_label => params[:account_label]
    }
  end

end

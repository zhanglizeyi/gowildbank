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
    #user = User.find_by username: username

    #input_name = user_params[:username]
    #input_name_exist = input_user.find_by username: input_name

    #input_email = user_params[:email]
    #input_email_exist = User.find_by email: input_email


    if user_data[:username] != "" && user_data[:email] != "" &&
      user_data[:salt] !="" && user_data[:encrypted_password] != ""
      #if !input_email_exist && !input_name_exist
        @user = User.new(user_data)
        @user.save
        print "save success"
        redirect_to("/login")
        #render 'new'
      else
        flash.notice = "invalid"
        #render 'new'
        print "save fails"
        render inline: "Can't access with less information, full fill"
      end
    #end
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

    label = create_account_params[:label]
    label_exist = user.bank_accounts.find_by label: label

    print "label_exist ==========================> #{label_exist}"

    #change the multiple label and nil label
    if !label_exist && label_exist != ""
      @bank_account.save
      redirect_to("/users/#{user.username}")
      print "created bank_account of type #{@bank_account.account_type}\n."
    else
      render inline: "Duplicate label OR empty Label!!!!"
      print "fail to create bank_account of type #{@bank_account.account_type}\n."
    end
    #redirect_to("/users/#{user.username}")
   
    # input_params = create_account_params
    # user = User.find_by username: input_params[:username]
    # @user = user
    # print "user is #{user}"
    # redirect_to "/users/#{@user.username}"
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

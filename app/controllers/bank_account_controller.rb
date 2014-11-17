class BankAccountController < ApplicationController
  
  def new
    @bank_account = BackAccount.new
  end

  def create
    input_account_params = create_account_params
    account_type = input_account_params[:account_type]
    label = input_account_params[:label]
    user_id = input_account_params[:user_id]

    user = User.find(user_id)
    if !user
      # report error says user not found, can not create account
      render inline: "No such user!!!"
      return
    end

    bank_account_data = {}
    bank_account_data[:account_type] = account_type
    bank_account_data[:balance] = 0.0
    bank_account_data[:label] = label
    @bank_account = BankAccount.new(bank_account_data)

    if @bank_account.save
      print "created bank_account of type #{@bank_account.account_type}\n."
    else
      print "fail to create bank_account of type #{@bank_account.account_type}\n."
    end
    redirect_to("/user/#{user.username}")
   
  end

  private
  def create_account_params
    params.require(:account).permit(:account_type, :user_id, :label)
  end

end

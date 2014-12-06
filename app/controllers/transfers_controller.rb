class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]
  helper_method :bank_accounts_options_for_current_user

  # GET /transfers
  # GET /transfers.json
  def index
    @transfers = Transfer.all
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
  end

  # GET /transfers/new
  def new
    if !logged_in?
      #flash[]...
      redirect_to '/login'
      return
    end

    @bank_account_options = bank_account_options_for_current_user
    @transfer = Transfer.new
  end


  def do_transaction(from_account, to_account, amount)
    from_account.balance -= amount
    to_account.balance += amount
    
    ActiveRecord::Base.transaction do
      from_account.save
      to_account.save
    end
  end

  # POST /transfers
  # POST /transfers.json
  def create

    input_params = transfer_params
    from_account_id = input_params[:from_account_id]
    
    # FIXME: id is actual label!!!
    to_account_label = input_params[:to_account_id]    
    amount = input_params[:amount].to_f

    from_account = BankAccount.find_by id: from_account_id
    if from_account.nil?
      render inline: "can not find sender"
      return
    end

    current_user_bank_account_ids = current_user.bank_accounts.map do |account| 
      account.id
    end 


    puts "from_account_id #{from_account_id}"
    puts "current_user_bank_account_ids #{current_user_bank_account_ids}"

    if !current_user_bank_account_ids.include?(from_account_id.to_i)
      render inline: "You can not operate on other's account"
      return
    end

    puts "to_account_label #{to_account_label}"
    to_account = BankAccount.find_by label: to_account_label

    if to_account.nil?
      render inline: "Can not find receiver"
      return
    end

    to_account_id = to_account.id

    transfer_data = {
      from_account_id: from_account_id,
      to_account_id: to_account_id,
      amount: amount
    }

    @transfer = Transfer.new(transfer_data)
    if @transfer.save
      if do_transaction(from_account, to_account, amount)
        puts "transfer success"
        redirect_to "/users/#{current_user.username}"
      else
        render inline: "transfer failed"
        return
      end
    else
      render inline: "transfer failed"
      return
    end
  end

  # PATCH/PUT /transfers/1
  # PATCH/PUT /transfers/1.json
  def update
    respond_to do |format|
      if @transfer.update(transfer_params)
        format.html { redirect_to @transfer, notice: 'Transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.json
  def destroy
    @transfer.destroy
    respond_to do |format|
      format.html { redirect_to transfers_url, notice: 'Transfer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # transfer 
  #find user
  def find_account

    input_params = find_account_params
    label = user.find_by label: params[:label]

    from_account = input_params[:From_Account]
    to_account = input_params[:To_Account]
    amount = input_params[:Amount]

    print "from_account =========================> #{from_account}"
    print "to_account =========================> #{to_account}"
    print "amount =============================> #{amount}"
  end

  def bank_account_options_for_current_user
    if current_user.nil? || current_user.bank_accounts.nil?
      return []
    end

    current_user.bank_accounts.map do |account|
      [account.label, account.id]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.require(:transfer).permit(:from_account_id, :to_account_id, :amount)
    end

    def get_balance_params
      params.require(:bank_accounts).permit(:label , :balance)
    end

    def find_account_params
      result = {
        :username => params[:username],
        :label => params[:amount][:label]
      }
    end
end

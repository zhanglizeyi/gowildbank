class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

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
    @transfer = Transfer.new
  end

  # POST /transfers
  # POST /transfers.json
  def create
    @transfer = Transfer.new(transfer_params)
    
    account_label = User.find_by params[:username]

    print "length ==================================> #{account_label}"

    if @transfer[:From_Account] == "" || @transfer[:To_Account] == "" ||
      @transfer[:Amount] == "" 
      render text: "input can not be empty!!"
    else
        if @transfer[:From_Account].length != 12 || @transfer[:To_Account].length != 12
          render text: "Could not find valid account"
        else
          respond_to do |format|
          if @transfer.save
            format.html { redirect_to @transfer, notice: 'Transfer was successfully created.' }
            format.json { render :show, status: :created, location: @transfer }
          else
            format.html { render :new }
            format.json { render json: @transfer.errors, status: :unprocessable_entity }
          end
        end
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.require(:transfer).permit(:From_Account, :To_Account, :Amount)
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

class DispaliesController < ApplicationController
  before_action :set_dispaly, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: "zzz", password: "1234", except: [:edit, :show]

  # GET /dispalies
  # GET /dispalies.json
  def index
    @dispalies = Dispaly.all
  end

  # GET /dispalies/1
  # GET /dispalies/1.json
  def show
  end

  # Get logoin
  def login
  end

  # GET /dispalies/new
  def new
    @dispaly = Dispaly.new
  end

  # GET /dispalies/1/edit
  def edit
    @dispaly = Dispaly.find(params[:id])
  end

  # POST /dispalies
  # POST /dispalies.json
  def create
  
    @dispaly = Dispaly.new(dispaly_params)

    respond_to do |format|
      if @dispaly.save
        format.html { redirect_to @dispaly, notice: 'Dispaly was successfully created.' }
        format.json { render :show, status: :created, location: @dispaly }
      else
        format.html { render :new }
        format.html { render :login }
        format.json { render json: @dispaly.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dispalies/1
  # PATCH/PUT /dispalies/1.json
  def update
    respond_to do |format|
      if @dispaly.update(dispaly_params)
        format.html { redirect_to @dispaly, notice: 'Dispaly was successfully updated.' }
        format.json { render :show, status: :ok, location: @dispaly }
      else
        format.html { render :edit }
        format.json { render json: @dispaly.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dispalies/1
  # DELETE /dispalies/1.json
  def destroy
    @dispaly.destroy
    respond_to do |format|
      format.html { redirect_to dispalies_url, notice: 'Dispaly was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   # Never trust parameters from the scary internet, only allow the white list through.
    def dispaly_params
      params.require(:dispaly).permit(:username, :password, :remember, :date)
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispaly
      @dispaly = Dispaly.find(params[:id])
    end

 
end

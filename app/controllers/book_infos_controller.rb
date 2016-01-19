class BookInfosController < ApplicationController
  before_action :set_book_info, only: [:show, :edit, :update, :destroy]

  # GET /book_infos
  # GET /book_infos.json
  def index
    @book_infos = BookInfo.all
  end

  # GET /book_infos/1
  # GET /book_infos/1.json
  def show
  end

  # GET /book_infos/new
  def new
    @book_info = BookInfo.new
  end

  # GET /book_infos/1/edit
  def edit
  end

  # POST /book_infos
  # POST /book_infos.json
  def create
    @book_info = BookInfo.new(book_info_params)

    respond_to do |format|
      if @book_info.save
        format.html { redirect_to @book_info, notice: 'Book info was successfully created.' }
        format.json { render :show, status: :created, location: @book_info }
      else
        format.html { render :new }
        format.json { render json: @book_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_infos/1
  # PATCH/PUT /book_infos/1.json
  def update
    respond_to do |format|
      if @book_info.update(book_info_params)
        format.html { redirect_to @book_info, notice: 'Book info was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_info }
      else
        format.html { render :edit }
        format.json { render json: @book_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_infos/1
  # DELETE /book_infos/1.json
  def destroy
    @book_info.destroy
    respond_to do |format|
      format.html { redirect_to book_infos_url, notice: 'Book info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_info
      @book_info = BookInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_info_params
      params.require(:book_info).permit(:isbn, :name, :cover)
    end
end

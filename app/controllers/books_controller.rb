class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :set_info, only: [:borrow_by_isbn]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sniffer
    isbn = params[:isbn]
    result = Fux::BookSniffer.sniff(isbn)
    render json: result
  end

  def borrow_by_isbn

    if @info.nil?
      @book = Book.new(book_params)
      @book.borrower = current_user
      @book = nil unless @book.save
    else
      @book = @info.books.find_by(user: nil)
    end

    if @book
      render json: {status: 'ok', borrowed_books: @current_user.borrowed_books}, status: :ok
    else
      @borrowed_users = @info.borrowed_users
      render json: {status: 'fail', errno: 'borrowed', users: @borrowed_users}, status: :ok
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    def set_info
      @info = BookInfo.find_by(isbn: pisbn)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(book_info_attributes: [:isbn, :name, :cover]).tap{ |book|
        book["book_info_attributes"]["isbn"].gsub!(/[- ]/, '')
      }
    end

    def pisbn
      book_params["book_info_attributes"]["isbn"]
    end

end

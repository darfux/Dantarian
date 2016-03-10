class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :set_info, only: [:borrow_by_isbn]
  skip_before_action :authenticate_user!, only:[:new_by_isbn, :create_by_scan]

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

  def new_by_isbn
    @isbn = params[:isbn]
    @metadata = Fux::BookSniffer.sniff(@isbn)
    @book = Book.new({book_info_attributes: @metadata})
    if @book.book_info.cover.empty?
      @book.book_info.cover = '/images/404book.gif'
    end
    @book_info = BookInfo.find_by(isbn: @isbn)
    render layout: 'mobile'
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

  def create_by_scan
    @book = Book.new(book_params)

    @save_success = @book.save
    render layout: 'mobile'
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
    bi = BookInfo.find_by(isbn: isbn)
    favored = false
    if bi.nil?
      result = Fux::BookSniffer.sniff(isbn)
      if result[:cover].empty?
        result[:cover] = '/images/404book.gif'
      end
    else
      result = {name: bi.name, cover: bi.cover, author: bi.author, source: bi.source}
      favored = !bi.users.find_by(id: current_user.id).nil?
    end
    result[:favored] = favored

    render json: result
  end

  def jd_get_isbn
    render text: Fux::ISBNSniffer.sniff_jd(params[:item_id])
  end

  def borrow_by_isbn
    if @info.nil?
      @book = Book.new(book_params)
    else
      @book = @info.books.find_by(user: nil)
    end

    if @book
      @book.borrower = current_user
      if @book.save
        render json: {status: 'ok', related_books: @current_user.related_books}, status: :ok
        return
      end
    end
    @borrowed_users = @info.borrowed_users
    unless @borrowed_users.empty?
      render json: {status: 'fail', errno: 'borrowed', users: @borrowed_users}, status: :ok
      return
    end
    render json: {status: 'fail', errno: 'no_copy'}, status: :ok
  end

  def ret
    @book = Book.find(params['book']['id'])
    @book.user = nil
    @book.save
    render json: {status: 'ok', related_books: @current_user.related_books}, status: :ok
  end

  def favor
    @isbn = params['isbn']
    @favored = !params['favored']
    @info = BookInfo.find_by(isbn: @isbn)

    if @info.nil?
      metadata = Fux::BookSniffer.sniff(@isbn)
      @info = BookInfo.new(metadata)
      @info.save!
      need_new_list = true
    end

    borrowed = !@current_user.books.where(book_info: @info).empty?
    if @favored
      @info.users << @current_user
    else
      @info.users.delete @current_user 
    end
    unless borrowed
      @book_list = @current_user.related_books
    end

    render json: {status: 'ok', isbn: @isbn, favored: @favored, book_list: @book_list}
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
      params.require(:book).permit(book_info_attributes: [:isbn, :name, :cover, :author, :source]).tap{ |book|
        book["book_info_attributes"]["isbn"].gsub!(/[- ]/, '')
        book["recorder_id"] = current_user.id
      }
    end

    def book_info_params
      params.require(:book).require(:book_info_attributes).permit(:isbn, :name, :cover, :author, :source).tap{ |bi|
        bi["isbn"].gsub!(/[- ]/, '')
      }
    end

    def pisbn
      book_info_params["isbn"]
    end

end

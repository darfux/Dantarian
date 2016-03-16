class UsersController < ApplicationController
  include Tubesock::Hijack

  before_action :set_user, only: [:show, :edit, :update, :destroy, :record_books, :record_books_socket]
  skip_before_action :authenticate_user!, only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def access_token
    target_path = (
      case params[:want_to]
      when 'record'
        book_record_path
      else
        nil
      end
    )
    @token = User::Token.generate(current_user, target_path)
    @token.save!
    render text: @token.to_s
  end

  def record_books
    respond_to do |format|
      format.html { render }
      format.json { render json: 
        {recent_record_books: @user.recent_record_books, total_record_num: @user.record_books.size} }
    end
  end

  # https://archive.dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/
  def record_books_socket
    hijack do |tubesock|

      tubesock.onopen do |data|
        tubesock.send_data({msg: 'hi'}.to_json)
      end
      
      tubesock.onclose do |data|
      end

      Thread.new do
        counter = 0
        key = {record_mark: @user.id}
        record_mark = Rails.cache.read(key) || 0
        loop do
          record_mark_now = Rails.cache.read(key) || 0
          if record_mark!=record_mark_now
            tubesock.send_data({msg: "update"}.to_json)
            record_mark = record_mark_now
            counter = 0
          end
          counter += 1
          break if counter > 1200
          sleep 0.5
        end
        tubesock.send_data({msg: "timeout", redirect_to: root_path}.to_json)
        tubesock.close
      end

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      uid = params[:id] || params[:user_id]
      @user = User.find(uid)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:account, :name, :nickname, :password, :password_confirmation)
    end
end

require 'test_helper'

class BookInfosControllerTest < ActionController::TestCase
  setup do
    @book_info = book_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_info" do
    assert_difference('BookInfo.count') do
      post :create, book_info: { cover: @book_info.cover, isbn: @book_info.isbn, name: @book_info.name }
    end

    assert_redirected_to book_info_path(assigns(:book_info))
  end

  test "should show book_info" do
    get :show, id: @book_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_info
    assert_response :success
  end

  test "should update book_info" do
    patch :update, id: @book_info, book_info: { cover: @book_info.cover, isbn: @book_info.isbn, name: @book_info.name }
    assert_redirected_to book_info_path(assigns(:book_info))
  end

  test "should destroy book_info" do
    assert_difference('BookInfo.count', -1) do
      delete :destroy, id: @book_info
    end

    assert_redirected_to book_infos_path
  end
end

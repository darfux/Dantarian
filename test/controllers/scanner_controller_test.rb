require 'test_helper'

class ScannerControllerTest < ActionController::TestCase
  test "should get book_record" do
    get :book_record
    assert_response :success
  end

end

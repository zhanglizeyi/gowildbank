require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test "should get contact_info" do
    get :contact_info
    assert_response :success
  end

end

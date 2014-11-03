require 'test_helper'

class DispaliesControllerTest < ActionController::TestCase
  setup do
    @dispaly = dispalies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dispalies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dispaly" do
    assert_difference('Dispaly.count') do
      post :create, dispaly: { date: @dispaly.date, password: @dispaly.password, remember: @dispaly.remember, username: @dispaly.username }
    end

    assert_redirected_to dispaly_path(assigns(:dispaly))
  end

  test "should show dispaly" do
    get :show, id: @dispaly
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dispaly
    assert_response :success
  end

  test "should update dispaly" do
    patch :update, id: @dispaly, dispaly: { date: @dispaly.date, password: @dispaly.password, remember: @dispaly.remember, username: @dispaly.username }
    assert_redirected_to dispaly_path(assigns(:dispaly))
  end

  test "should destroy dispaly" do
    assert_difference('Dispaly.count', -1) do
      delete :destroy, id: @dispaly
    end

    assert_redirected_to dispalies_path
  end
end

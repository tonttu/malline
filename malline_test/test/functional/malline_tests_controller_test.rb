require File.dirname(__FILE__) + '/../test_helper'

class MallineTestsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:malline_tests)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_malline_test
    assert_difference('MallineTest.count') do
      post :create, :malline_test => { }
    end

    assert_redirected_to malline_test_path(assigns(:malline_test))
  end

  def test_should_show_malline_test
    get :show, :id => malline_tests(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => malline_tests(:one).id
    assert_response :success
  end

  def test_should_update_malline_test
    put :update, :id => malline_tests(:one).id, :malline_test => { }
    assert_redirected_to malline_test_path(assigns(:malline_test))
  end

  def test_should_destroy_malline_test
    assert_difference('MallineTest.count', -1) do
      delete :destroy, :id => malline_tests(:one).id
    end

    assert_redirected_to malline_tests_path
  end
end

require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get steps_create_url
    assert_response :success
  end

  test "should get traveldiary" do
    get steps_traveldiary_url
    assert_response :success
  end

end

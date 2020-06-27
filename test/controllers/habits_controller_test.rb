require 'test_helper'

class HabitsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get habits_new_url
    assert_response :success
  end

end

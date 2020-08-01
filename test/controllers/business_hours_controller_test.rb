require 'test_helper'

class BusinessHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_hour = business_hours(:one)
  end

  test "should get index" do
    get business_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_business_hour_url
    assert_response :success
  end

  test "should create business_hour" do
    assert_difference('BusinessHour.count') do
      post business_hours_url, params: { business_hour: { business_id: @business_hour.business_id, close: @business_hour.close, day: @business_hour.day, open: @business_hour.open } }
    end

    assert_redirected_to business_hour_url(BusinessHour.last)
  end

  test "should show business_hour" do
    get business_hour_url(@business_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_hour_url(@business_hour)
    assert_response :success
  end

  test "should update business_hour" do
    patch business_hour_url(@business_hour), params: { business_hour: { business_id: @business_hour.business_id, close: @business_hour.close, day: @business_hour.day, open: @business_hour.open } }
    assert_redirected_to business_hour_url(@business_hour)
  end

  test "should destroy business_hour" do
    assert_difference('BusinessHour.count', -1) do
      delete business_hour_url(@business_hour)
    end

    assert_redirected_to business_hours_url
  end
end

require "application_system_test_case"

class BusinessHoursTest < ApplicationSystemTestCase
  setup do
    @business_hour = business_hours(:one)
  end

  test "visiting the index" do
    visit business_hours_url
    assert_selector "h1", text: "Business Hours"
  end

  test "creating a Business hour" do
    visit business_hours_url
    click_on "New Business Hour"

    fill_in "Business", with: @business_hour.business_id
    fill_in "Close", with: @business_hour.close
    fill_in "Day", with: @business_hour.day
    fill_in "Open", with: @business_hour.open
    click_on "Create Business hour"

    assert_text "Business hour was successfully created"
    click_on "Back"
  end

  test "updating a Business hour" do
    visit business_hours_url
    click_on "Edit", match: :first

    fill_in "Business", with: @business_hour.business_id
    fill_in "Close", with: @business_hour.close
    fill_in "Day", with: @business_hour.day
    fill_in "Open", with: @business_hour.open
    click_on "Update Business hour"

    assert_text "Business hour was successfully updated"
    click_on "Back"
  end

  test "destroying a Business hour" do
    visit business_hours_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Business hour was successfully destroyed"
  end
end

require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "check existance of 10 letters to choose" do
    visit root_url
 
    assert_selector "li", count: 10 
  end

  test "get a message if the word is wrong" do
    word = "asdfasdfasdf"
    visit root_url

    fill_in "word", with: word 
    click_on "Play"

    assert_text "Sorry but \"#{word}\""
  end
end

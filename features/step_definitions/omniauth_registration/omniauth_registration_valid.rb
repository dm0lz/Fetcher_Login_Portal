Given /^i am a registrated fetcher user$/ do
  #pending # express the regexp above with the code you wish you had
end

When /^i add my twitter account$/ do
  #binding.pry
  sleep 3
  browser.element(:css => '.btn-info').click
  browser.text_field(:name => "session[username_or_email]").set("a4b8c16@gmail.com")
  browser.text_field(:name => "session[password]").set("fetcher")
  browser.element(:css => '#allow').click
  sleep 4
  #browser.element(:css => '.btn.btn-danger.btn-large').click
  #browser.goto "http://localhost:4567/"
  #binding.pry
end

Then /^i should have my access token inserted into database$/ do

  #binding.pry
  sleep 5
  collPersonUser.find({"itemId" => 308762265}).collect{|i| p i}.empty?.should be_false
  # Empty session
  browser.element(:css => '.btn.btn-danger.btn-large').click
  sleep 3
end


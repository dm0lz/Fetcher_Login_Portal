Given /^i am a registrated fetcher user with one account already added$/ do
  #pending # express the regexp above with the code you wish you had
  browser.goto "https://twitter.com/logout"
  sleep 4
  browser.element(:css => '.btn.primary-btn.js-submit').click
  sleep 3
  #binding.pry
end

When /^i add a second twitter account$/ do
  #browser.element(:css => '.btn.btn-danger.btn-large').click
  sleep 2
  browser.goto "http://localhost:4567/"	
	#binding.pry
  sleep 3
  browser.element(:css => '.btn-info').click
  sleep 2
  browser.text_field(:name => "session[username_or_email]").set("ducrouxolivier@gmail.com")
  browser.text_field(:name => "session[password]").set("fetcher")
  #binding.pry
  browser.element(:css => '#allow').click
  #binding.pry
  sleep 4
  browser.element(:css => 'a.btn.btn-info.btn-large').click
  sleep 4
end

Then /^i should have its access token inserted into database$/ do
  #pending # express the regexp above with the code you wish you had
  sleep 2
end

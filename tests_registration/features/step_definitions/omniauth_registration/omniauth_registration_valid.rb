Given /^i am a registrated fetcher user$/ do
  #pending # express the regexp above with the code you wish you had
end

When /^i add my twitter account$/ do
  #binding.pry
  browser.element(:css => '.btn-info').click
  browser.text_field(:name => "session[username_or_email]").set("a4b8c16@gmail.com")
  browser.text_field(:name => "session[password]").set("fetcher")
  browser.element(:css => '#allow').click
  browser.element(:css => 'a.btn.btn-info.btn-large').click

end

Then /^i should have my access token inserted into database$/ do
	collPersonUser.find({"Item#id" => 308762265}).collect{|i| p i}.empty?.should be_false
end


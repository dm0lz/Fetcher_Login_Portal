When /^i register with an email that is already existing in database$/ do
	#binding.pry
  browser.text_field(:name => "inputUsername").set("jean")
  browser.text_field(:name => "inputEmail").set("jean@fetcher.com")
  browser.text_field(:name => "inputPassword", :type => "password").set("password")
  browser.text_field(:name => "inputPasswordConfirm", :type => "password").set("password")
  browser.element(:css => '.btn').click

end

Then /^i should see an error message with email$/ do
	#binding.pry
	browser.text.should include "email"
end

When /^i register with a blank password$/ do
  browser.text_field(:name => "inputUsername").set("jean")
  browser.text_field(:name => "inputEmail").set("jean@fetcher.com")
  browser.text_field(:name => "inputPassword", :type => "password").set("")
  browser.text_field(:name => "inputPasswordConfirm", :type => "password").set("")
  browser.element(:css => '.btn').click
end
Then /^i should see an error message with blank password$/ do
  #binding.pry
  browser.text.should include "blank"
end

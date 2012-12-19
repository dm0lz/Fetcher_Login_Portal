When /^i register with an invalid password\/passwordConfirmation combination$/ do
 browser.text_field(:name => "inputUsername").set("jean")
  browser.text_field(:name => "inputEmail").set("jean@fetcher.com")
  browser.text_field(:name => "inputPassword", :type => "password").set("password")
  browser.text_field(:name => "inputPasswordConfirm", :type => "password").set("passworderror")
  browser.element(:css => '.btn').click
end

Then /^my data should not be inserted in the database$/ do
#binding.pry
  coll.find("login" => "jean").any?.should == false 
end

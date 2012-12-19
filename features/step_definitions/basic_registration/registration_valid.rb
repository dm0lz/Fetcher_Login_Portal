Given /^i am a fetcher user$/ do
  #pending # express the regexp above with the code you wish you had
end

When /^i register with everything valid$/ do
  browser.text_field(:name => "inputUsername").set("jean")
  browser.text_field(:name => "inputEmail").set("jean@fetcher.com")
  browser.text_field(:name => "inputPassword", :type => "password").set("password")
  browser.text_field(:name => "inputPasswordConfirm", :type => "password").set("password")
  browser.element(:css => '.btn').click
  #binding.pry
end

Then /^my data should be inserted in the database$/ do

  coll.find("login" => "jean").any?.should be_true 
end

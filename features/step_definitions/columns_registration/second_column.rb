Given /^am fetcher user$/ do
  #pending # express the regexp above with the code you wish you had
end

When /^he fills the forms$/ do

  browser.text_field(:name => "filter").set("filteredWord")
  browser.text_field(:name => "streamType").set("track")
  browser.text_field(:name => "streamArgument").set("merkel")
  browser.element(:css => '.btn').click
end

Then /^its data should be inserted into db$/ do
  #pending # express the regexp above with the code you wish you had
  sleep 5
end

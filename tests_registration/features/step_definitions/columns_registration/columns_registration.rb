Given /^a fetcher user$/ do
  #pending # express the regexp above with the code you wish you had
end

When /^i fill the form$/ do
  browser.text_field(:name => "filter").set("fetcher")
  browser.text_field(:name => "streamType").set("track")
  browser.text_field(:name => "streamArgument").set("kirchner")
  browser.element(:css => '.btn').click
end

Then /^my data gets inserted into mongodb$/ do
  #pending # express the regexp above with the code you wish you had
end

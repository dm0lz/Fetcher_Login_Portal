@column
Feature: User adds columns

	As a fetcher user
	I want to be able to add columns
	So that my data get inserted into mongo

	Background: 
		Given a fetcher is connecting to http://localhost:4568/
		
	Scenario: user adds a first column
		Given a fetcher user
		When i fill the form
		Then my data gets inserted into mongodb

	Scenario: user adds a second column
		Given am fetcher user
		When he fills the forms
		Then its data should be inserted into db

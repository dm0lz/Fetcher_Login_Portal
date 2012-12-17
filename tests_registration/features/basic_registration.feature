@basic
Feature: User Registers

	As a fetcher user
	In order to be able to use the fetcher product
	I want to be able to register

	Background: 
		Given fetcher user connects to http://localhost:4566/

	@valid 
	Scenario: Register with all valid data
		Given i am a fetcher user
		When i register with everything valid
		Then my data should be inserted in the database 

	@invalid
	Scenario: Register with password confirm different from password
		Given i am a fetcher user
		When i register with an invalid password/passwordConfirmation combination
		Then my data should not be inserted in the database 

	@invalid2
	Scenario: Register with already existing email in database
		Given i am a fetcher user
		When i register with an email that is already existing in database
		Then i should see an error message with email

	@invalid3
	Scenario: Register with blank password
		Given i am a fetcher user
		When i register with a blank password
		Then i should see an error message with blank password

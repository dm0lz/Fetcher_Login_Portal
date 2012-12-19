@omniauth
Feature: User adds Social Network Accounts

	As a fetcher user
	I want to be able to add social networks accounts to my current fetcher account
	So that my access token get inserted in mongodb

    Background: 
    	Given a fetcher user connects to http://localhost:4567/
	
	Scenario: User adds a twitter account
		Given i am a registrated fetcher user
		When i add my twitter account 
		Then i should have my access token inserted into database

		
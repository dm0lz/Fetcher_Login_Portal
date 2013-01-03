module MongoTest
	def browser
		@browser ||= Watir::Browser.new :firefox
	end
	def start port
		browser.goto "http://localhost:#{port}/"
	end
	def stop
		browser.close
	end
	def client
    @client ||= Mongo::Connection.new("cfg1.database", "27017")
  end
  def db
    @db ||= client["mongoid"]
  end
  def coll
    @coll ||= db["User"]
  end
  def collPersonUser
  	@collPersonUser ||= db["PersonUser"]
  end
end


World MongoTest
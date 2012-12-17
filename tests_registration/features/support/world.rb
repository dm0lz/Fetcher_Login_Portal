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
    @client ||= Mongo::Connection.new("mongocfg1.fetcher")
  end
  def db
    @db ||= client["test"]
  end
  def coll
    @coll ||= db["users"]
  end
  def collPersonUser
  	@collPersonUser ||= db["http://schema.org/Person/User"]
  end
end


World MongoTest
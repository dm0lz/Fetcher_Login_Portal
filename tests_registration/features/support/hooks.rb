
Before do
	#start
end

After "@basic" do
	#binding.pry
	stop
	unless coll.find({"email" => "jean@fetcher.com"}).collect{|i| p i}.empty?
		user_object_id_to_remove = coll.find.sort({"_id" => :desc}).limit(1).collect{|i| p i}[0]["_id"]
		coll.remove({"_id" => user_object_id_to_remove})
	end
end

After "@omniauth" do
	#binding.pry
	stop
	unless collPersonUser.find({"Item#id" => "308762265"}).collect{|i| p i}.empty?
		user_object_id_to_remove = coll.find.sort({"_id" => :desc}).limit(1).collect{|i| p i}[0]["_id"]
		coll.remove({"_id" => user_object_id_to_remove})
	end
end

Before "@invalid2" do
	a = { "login" => "louis", "email" => "jean@fetcher.com", "password" => "password" }
 	object_id = coll.insert a
end


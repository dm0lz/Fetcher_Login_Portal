#!/usr/bin/env ruby

system "cd /home/fetcher/Desktop/Fetcher_Login_Portal/RegisterSession && nohup ruby run_register.rb &"
system "cd /home/fetcher/Desktop/Fetcher_Login_Portal/omniauth && nohup ruby run_omniauth.rb &"
system "cd /home/fetcher/Desktop/Fetcher_Login_Portal/mongoInterface && nohup ruby run_mongoInterface.rb &"
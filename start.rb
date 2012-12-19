#!/usr/bin/env ruby

system "cd RegisterSession && nohup ruby run_register.rb &"
system "cd omniauth && nohup ruby run_omniauth.rb &"
system "cd mongoInterface && nohup ruby run_mongoInterface.rb &"
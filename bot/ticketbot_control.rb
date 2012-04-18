require 'rubygems'
require 'daemons'

Daemons.run('ticketbot.rb', :dir_mode => :system) 

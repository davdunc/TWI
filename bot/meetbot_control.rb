require 'rubygems'
require 'daemons'
require 'worker'

Daemons.run('meetbot.rb', :dir_mode => :system) 


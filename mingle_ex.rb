#!/usr/bin/ruby

require 'rubygems'
require 'ticketmaster'
require 'ticketmaster-mingle'
require 'logger'

#log = Logger.new(STDOUT)			
# mingle = TicketMaster.new(:mingle, {:server => 'mingle01.thoughtworks.com', :username=> 'gauravka', :password => 'READ0n1y!808'})
#log.info mingle.to_s
#project = mingle.projects
#log.info project.to_s
#ticket = project.ticket!({:name => "New ticket_GK", :description=> "Body for the very new ticket"})

require 'net/smtp'

msg = "Subject: There!\n\nThis works, and this part is in the body."
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
        smtp.enable_starttls
            smtp.start('gmail.com', 'gkasera@gmail.com', 'kasera84GK', :login) do
                  smtp.send_message(msg, 'gkasera@gmail.com', 'gauravka@thoughtworks.com')
                      end
#

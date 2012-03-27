require 'rubygems'
require 'active_resource'
require 'net/smtp'


class Card < ActiveResource::Base
	self.site='http://mingle01.thoughtworks.com/api/v2/projects/devops_india_practice_tracker'
        self.user='gauravka'
	self.password= 'READ0n1y!808'
	self.format=:xml
end

d_c = 0 #DevCloud Issues
a_c = 0 #cards in analysis
rd_c = 0 #cards in ready for development
id_c = 0 #cards in In Development
dc_c = 0 #Development complete
not_set = 0 # Ticket without status

cards= Card.find(:all, :params => {:page => "all"})

	cards.each do |card|

		if card.card_type.name == "DevCloud Issues"
		
			if card.properties.first.attributes[:value] == 'Analysis'
			a_c = a_c + 1
			
			elsif card.properties.first.attributes[:value] ==  'Ready For Development' 
			rd_c = rd_c + 1

        		elsif card.properties.first.attributes[:value] ==  'In Development'
		        id_c = id_c + 1
		        
			elsif card.properties.first.attributes[:value] ==  'Development Complete'
		        dc_c = dc_c + 1
		        
			else 
			not_set = not_set + 1

			end

		d_c = d_c + 1

		end
	end

Result = String.new

if a_c != 0
Result << "Cards in Analysis = #{a_c}\n"
end

if rd_c != 0
Result << "Cards ready for Development = #{rd_c}\n"
end

if id_c != 0
Result << "Cards in Development = #{id_c}\n"
end

if d_c != 0
Result << "Cards Completed = #{dc_c}\n"
end

Result << "Total no of cards = #{d_c}"

puts Result

#Result = "Cards in Analysis = #{a_c} 
#	  Cards ready for Development = #{rd_c} 
#	  Cards in Development = #{id_c}
#          Cards completed = #{dc_c} 

#  Total no of cards = #{d_c}"

#p Result
#to_addr = ['gkasera@gmail.com', 'gauravka@thoughtworks.com', 'ranjibd@thoughtworks.com']
#msg = "Subject: Weekly Devcloud Issue Report\n\n #{Result}"
#    smtp = Net::SMTP.new 'smtp.gmail.com', 587

#        smtp.enable_starttls
#            smtp.start('gmail.com', 'gauravka@thoughtworks.com', 'READ0n1y!808', :login) do          
#                  smtp.send_message(msg, 'gauravka@thoughtworks.com', to_addr) 
#                      end           
                                                    

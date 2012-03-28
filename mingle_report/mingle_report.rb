require 'rubygems'
require 'active_resource'
require 'net/smtp'
require 'pony'

class Card < ActiveResource::Base
	self.site='http://mingle01.thoughtworks.com/api/v2/projects/devops_india_practice_tracker'
        self.user='gauravka'
	self.password= 'READ0n1y!808'
	self.format=:xml
end

def count(category)

d_c= 0 
a_c = 0 #cards in analysis
rd_c = 0 #cards in ready for development
id_c = 0 #cards in In Development
dc_c = 0 #Development complete
not_set = 0

cards= Card.find(:all, :params => {:page => "all"})
cards.each do |card|
	if card.card_type.name == "DevCloud Issues" and card.properties[2].attributes[:value] == category
				
			if card.properties.first.attributes[:value] ==  'Analysis'
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


result = "For "+category+":\n"

	if a_c != 0
	result << "Cards in Analysis = #{a_c}\n"
	end
	if rd_c != 0
	result << "Cards ready for Development = #{rd_c}\n"
	end
	if id_c != 0
	result << "Cards in Development = #{id_c}\n"
	end
	if d_c != 0
	result << "Cards Completed = #{dc_c}\n"
	end
	result << "Total no of cards = #{d_c}\n\n"

return result

end

card = Card.new
count = 0
card1= Card.find(:all, :params => {:page => "all"})

card1.each do |card|
	if card.card_type.name == "DevCloud Issues"
	count = count +1
	end
end

Result1 = count('Access Request')
Result2 = count('Performance Issue')
Result3 = count('Update/Upgrade')
Result4 = count


#p Result1
#p Result2
#p Result3
#p Result4

#to_addr = ['devops-in@thoughtworks.com','ranjibd@thoughtworks.com']
#msg ="Subject: Weekly Devcloud Report"+" "+Date.today.to_s+"\n\n #{Result1}\n #{Result2}\n #{Result3}\n Total no of Cards= #{Result4}"
#    smtp = Net::SMTP.new 'smtp.gmail.com', 587
#        smtp.enable_starttls
#            smtp.start('gmail.com', 'gauravka@thoughtworks.com', 'READ0n1y!808', :login) do          
#                  smtp.send_message(msg, 'gauravka@thoughtworks.com', to_addr) 
        
#end              


email_data = {
  :from             =>  'Gaurav Kasera <gauravka@thoughtworks.com>',
  :to               =>  'devops-in@thoughtworks.com',
  :subject          =>  "Weekly Devcloud Report"+" "+Date.today.to_s+".",
  :body             =>  "#{Result1}\n #{Result2}\n #{Result3}\n Total no of Cards= #{Result4}",
 # :html_body        =>  haml :email, # render html email using haml
   :port             =>  '587',
   :via              =>  :smtp,
   :via_options      =>  {
   :address                  =>  'smtp.gmail.com',
   :port                     =>  '587',
   :enable_starttls_auto     =>  true,
   :user_name                =>  'gauravka@thoughtworks.com',
   :password                 =>  'READ0n1y!808',
   :authentication           =>  :plain,
   :domain                   =>  'mydomain.com'
                         }
               }
Pony.mail(email_data)


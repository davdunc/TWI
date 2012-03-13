require 'cinch'
require 'rubygems'
require 'active_resource'

class Card < ActiveResource::Base                                                          
        self.site='http://mingle01.thoughtworks.com/api/v2/projects/devops_india_practice_tracker'  
        self.user='gauravka'
        self.password= 'READ0n1y!808'                                                      
        self.format=:xml                                                                   
end

def ticket(num)
card_last = Card.find(:first)
last = card_last.number
if num.to_i > last.to_i
 return "Card does not exist"
end
card = Card.find(num)

if (card.card_type.name == "DevCloud Issues")
	ret =<<-EOF
		Card No:#{card.number}
		Name:- #{card.name}
		Type= #{card.card_type.name}
		Category= #{card.properties[2].attributes[:value]}
		Stage= #{card.properties.first.attributes[:value]}
		EOF
return ret
else
return "Not a DevCloud Issue"
end
end
def new()

end

def count()
card1 = Card.find(:all, :params => {:page => "all"})
n = 0
card1.each do |card|
	if card.card_type.name == 'DevCloud Issues'
	n = n +1
	end
end
return n
end


def countc(category)
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
result = "For "+category+"
          Cards in Analysis = #{a_c} 
          Cards ready for Development = #{rd_c} 
          Cards in Development = #{id_c}
          Cards completed = #{dc_c} 
          Total no of cards = #{d_c}"

return result
end

def create(nam)
card = Card.new
card.name = nam
card.card_type_name = 'DevCloud Issues'
card.save
ret = "New Card Created: #{card.id} :: #{card.name}\n Type = #{card.card_type_name}"
return ret
end

def updates(num, stg)
ticket = ticket(num)

end

def report()
res1 = countc('Access Request')
res2 = countc('Performance Issue')
res3 = countc('Update/Upgrade')
res4 = count()
final =  "Devcloud Report\n\n #{res1}\n #{res2}\n #{res3}\n Total no of Cards= #{res4}"
return final
end

def auth(usr)
val_user = ['ranjib','nileshb', 'gaurav']
val_user.each do |n|
	if n == usr
	return "Pass"
	end
end
return "Fail"
end


bot = Cinch::Bot.new do
  configure do |c|
    c.server = "sifyirc01.thoughtworks.com"
    c.channels = ["#devcloud"]
    c.nick = "ticketbot"
  end

  on :message, /^hello+/ do |m|
    m.reply "Hellooooooo, #{m.user.nick}"
    m.reply m.user.nick
  end

  

  on :message, /^!ticket show (\d+)/ do |m, cnum|
  val = ticket(cnum)
   m.reply "#{val}"
  end

  on :message, "!ticket show all" do |m|
	mal = count()
 	m.reply "Total DevCloud Issues=#{mal}"
  end
 
  on :message, /^!ticket category (\w+\/\w+)/ do |m, tcat|
         t_cat = countc(tcat)
         m.reply "#{t_cat}"
  end
  on :message, /^!ticket category (\w+ \w+)/ do |m, tcat|
         t_cat = countc(tcat)
         m.reply "#{t_cat}"
  end

  on :message, "!ticket report" do |m|
	dc_report = report()
	m.reply "DevCloud Issues Report = #{dc_report}"
  end

  on :message, /!ticket create (.*)/ do |m, word|
        check = auth(m.user.nick)
	if check == "Pass"
		wd = create(word)
        	m.reply "#{wd}"
	else 
		m.reply "Dont have access to create a card"
	end
  end
end 

bot.start


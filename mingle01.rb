require 'rubygems'
require 'active_resource'
require 'net/smtp'

class Card < ActiveResource::Base
	
	self.site='http://mingle01.thoughtworks.com/api/v2/projects/devops_india_practice_tracker'
        self.user='gauravka'
	self.password= 'READ0n1y!808'
	self.format=:xml
       	attr_accessor :properties
end



#cards1= Card.find(72)
#if !Card.find(72)
#ctiveResource::ResourceNotFound
#p "Card not found"
#else
#p cards1
#p cards1.number
#p cards1.name
#p cards1.card_type.name
#end

begin
  card = Card.find(72)
rescue ActiveResource::ResourceNotFound
  p "Card not found"
end
#p cards1.properties[2].attributes[:value]
#p cards1.properties[0].attributes[:value]
#p cards1.properties[1].attributes[:value]
#count = 0
#if cards1.properties[2].attributes[:value] == 'Update/Upgrade'
#	puts "found card ready for upgrade"
#end 

#	cards1.properties.each do |cp|
#	puts cp.attributes[:value]
	
#	end
#puts count



#def create(nam)
#card = Card.new#(:name => nam, :description => "dummy", :properties => {:name => 'stage',:value => 'analysis'})
#card.name = nam
#card.properties.first.attributes[:value] = cat
#card.type = 'DevCloud Issues'
#card.card_type_name = 'DevCloud Issues'
#puts "\nproperties : \n"
#p card.properties#('Owner','gauravka')
#card. = 'Analysis'
#card.save
#return card
#end



card2 = create('test dummy')
puts "card ctreated : \n"
p  card2



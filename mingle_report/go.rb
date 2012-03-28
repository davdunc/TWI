require 'rubygems'
require 'open-uri'
require 'nokogiri'
 
doc = Nokogiri::HTML(open("http://gauravka@'READ0n1y!808'@vm100-004.sc01.thoughtworks.com:8153/go/api/pipelines.xml"))
doc.xpath('//h3/a').each do |node|
  puts node.text
end

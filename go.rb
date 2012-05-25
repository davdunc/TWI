require 'rubygems'
require 'active_resource'
require 'pony'
require 'logger'
require 'go_api_client'
#require 'rest-open-uri'
require 'net/http'


#GoApiClient.runs('10.10.100.51:8153')


class PipelineXMLFormatter
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    ActiveSupport::XmlMini.decode(xml)["pipeline"]
  end
end




#class Pipeline < ActiveResource::Base
#	self.site='http://vm100-004.sc01.thoughtworks.com:8153/go/api'
#        self.user='pratima'
#	self.password= ')3vcl0u)K@rm'
#	self.element_name= "pipeline"
#	self.format=PipelineXMLFormatter.new
#end

class Pipeline < ActiveResource::Base
	self.site='http://vm100-004.sc01.thoughtworks.com:8153/go/api/'
        self.user='pratima'
	self.password= ')3vcl0u)K@rm'
#	self.element_name= "pipeline"
	self.format=:xml
end

ActiveResource::Base.logger = Logger.new(STDOUT)

pipe = Pipeline.get(:stages)#"VodQaTeam1")

#go=Pipeline.new({:pipeline_name => 'Test1'})

#p go
#pipe = Go.find(:first)


puts pipe
#card = Go.new
	#card1= Go.find(:all, :params => {:page => "all"})
puts "result"
#puts pipe


#ret = Go.get(:all)

#puts "#{ret}"

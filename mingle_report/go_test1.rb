require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'active_resource'
require 'net/http'
require 'time'

pipeline_url = open("http://vm100-004.sc01.thoughtworks.com:8153/go/cctray.xml", :http_basic_authentication => ["gauravka", "READ0n1y!808"])
doc = Nokogiri::XML(pipeline_url.read)

pipeline_data = doc.xpath('//Project')

WebNameUrls = Hash.new
pipeline_data.each do |fp|
  pipeline_name = fp["name"].split(" :: ")[0]
  webUrl_temp = fp["webUrl"].sub("tab/build/detail","pipelines")
  webUrl = webUrl_temp.split('/')[0, webUrl_temp.split('/').length-1].join('/')
  WebNameUrls["#{pipeline_name}"] = "#{webUrl}"
end

WebNameUrls.each do |pipeline_name,weburl|
	p1 = pipeline_name.to_s
	rej = ["DeployToEnvironments","DeployToQA01-SiteRefresh","smoke"]
	if rej.include? p1 == "True"
	WebNameUrls.delete(pipeline_name)
	end
#	 puts "#{pipeline_name}"
  end


WebNameUrls.each do |pipeline_name,weburl|

#  reject = ["DeployToEnvironments","DeployToQA01-SiteRefresh","smoke"]

     if pipeline_name != "DeployToEnvironments" 
     if pipeline_name != "smoke"    
     if pipeline_name != "DeployToQA01-SiteRefresh"    
     stages_prefix = "http://vm100-004.sc01.thoughtworks.com:8153/go/api/pipelines/"
     stages_url = stages_prefix + "#{pipeline_name}" + "/stages.xml" 
#     print "#{stages_url} \n"
     source = open(stages_url, :http_basic_authentication=>["gauravka", "READ0n1y!808"])
     str = source.read
     @stages_doc =  Nokogiri::XML(str)
pipeline_link = @stages_doc.xpath("//xmlns:entry[xmlns:id='#{weburl}' and xmlns:link[@title='#{pipeline_name} Pipeline Detail']]/xmlns:link[@type='application/vnd.go+xml' and @title='#{pipeline_name} Pipeline Detail']/@href").text()
     puts pipeline_link

     pipe =  pipeline_name.to_s.downcase
     pipeline_title = []
     @stages_doc.xpath("//xmlns:title").each do |title|
	  temp = title.text()
	  temp = temp.split('stage')[1]
	  temp = temp.to_s.split(')')[0]
	  temp = temp.to_s.gsub(/\(/, "_")
	  temp = temp.to_s.strip.downcase
	  pipeline_title.push(temp)
          end

     pipeline_updated = []
     @stages_doc.xpath("//xmlns:updated").each do |date|
           pipeline_updated.push(Time.parse(date.text()))
     end
     hash = Hash[pipeline_title.zip(pipeline_updated)]
     time = Time.now
     hash.each do |pipeline_title, pipeline_updated|
#	   	if ((time-pipeline_updated)<= 86400)
          	puts "#{pipe}"+"."+"#{pipeline_title}" + "." + "#{pipeline_updated.to_i}"
#	   	end
	   end
   end
end
end
end


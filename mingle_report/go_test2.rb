require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'active_resource'
require 'net/http'
require 'time'

pipeline_url = open("http://vm100-004.sc01.thoughtworks.com:8153/go/cctray.xml", :http_basic_authentication => ["gauravka", "READ0n1y!808"])
doc = Nokogiri::XML(pipeline_url.read)
pipeline_data = doc.xpath('//Project')
Pipeline_1 = Hash.new
pipeline_data.each do |fp|
  pipeline_name = fp["name"].split(" :: ")[0]
  lastbuild_time = fp["lastBuildTime"]
  Pipeline_1["#{pipeline_name}"] = "#{lastbuild_time}"
end

Pipeline_2 = Hash.new
pipeline_data.each do |fp|
  pipeline = fp["name"].split(" :: ")[0]
  stage = fp["name"].split(" :: ")[1]
   Pipeline_2["#{pipeline}"] = "#{stage}"
    end

Pipeline_1.each{|i,j| j.to_s}
p_name = []
Pipeline_1.each do |pipeline_name,time|
	t1 = Time.now
	t2 = Time.parse(time)
	if ((t1-t2)<= 86400)
	 p_name.push(pipeline_name)
  end
end

Pipeline_2.delete_if{|pipe, stage| !p_name.include? pipe}

	Pipeline_2.each do |pipe, stage|
     stages_prefix = "http://vm100-004.sc01.thoughtworks.com:8153/go/api/pipelines/"
     stages_url = stages_prefix + "#{pipe}" + "/stages.xml" 
     source = open(stages_url, :http_basic_authentication=>["gauravka", "READ0n1y!808"])
     str = source.read
     @stages_doc =  Nokogiri::XML(str)
     pipeline_link = @stages_doc.xpath("//xmlns:entry/xmlns:link[@rel='alternate' and @type='application/vnd.go+xml']/@href")#.text()
		 		pipeline_link.each do |pl|
				stage_detail = open(pl, :http_basic_authentication=>["gauravka", "READ0n1y!808"]).read 
				job_doc = Nokogiri::XML(stage_detail)
				job_link = job_doc.xpath("//jobs/job/@href")
				job_link.each do |jl|

						job_detail = open(jl, :http_basic_authentication=>["gauravka", "READ0n1y!808"]).read
      			j_doc = Nokogiri::XML(job_detail)
						s_t = j_doc.xpath("//properties/property[@name='cruise_timestamp_01_scheduled']").text
						a_t = j_doc.xpath("//properties/property[@name='cruise_timestamp_02_assigned']").text
						p_t = j_doc.xpath("//properties/property[@name='cruise_timestamp_03_preparing']").text
						b_t = j_doc.xpath("//properties/property[@name='cruise_timestamp_04_building']").text
						c_t = j_doc.xpath("//properties/property[@name='cruise_timestamp_05_completing']").text
						end_time = j_doc.xpath("//properties/property[@name='cruise_timestamp_06_completed']").text
						job = j_doc.xpath("//job/@name")
						stg = j_doc.xpath("//stage/@name")
						cnt = j_doc.xpath("//stage/@counter")
						agent = j_doc.xpath("//properties/property[@name='cruise_agent']").text
#						job_name = job[@name]
#						puts "-------------------------------------------------"
#						puts job
#						puts "-------------------------------------------------"
#						puts j_doc.job[@name]	
						scheduling = Time.parse(a_t) - Time.parse(s_t)
						assignment = Time.parse(p_t) - Time.parse(a_t)
						preparation = Time.parse(b_t) - Time.parse(p_t)
						building = Time.parse(c_t) - Time.parse(b_t)
						completion = Time.parse(end_time) - Time.parse(c_t)
						t_period = Time.parse(end_time) - Time.parse(s_t)
						puts "#{pipe.downcase}"+"."+"#{stg.to_s.downcase}"+"_"+"#{cnt}"+"."+"#{job}"+"."+"#{agent}"+"."+"#{t_period.to_i}"+"."+"#{Time.parse(s_t).to_i}"
						end
				end
   end


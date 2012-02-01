require 'pp'
require 'json'
require 'apns'
require 'xmlsimple'
require 'date'
require 'lib/api/fore.rb'
require "net/http"
require "net/https"



class ServerCommunicationController < ApplicationController
  skip_before_filter :verify_authenticity_token 

  ADD_TASK_HOST                         = 'http://dump-them.appspot.com'
  ADD_TASK_URI                          = '/schedule/'
  
  
  def intitiate_response_object    
    response_object              = Hash.new
    response_object[:status]     = "failure"
    response_object[:statusCode] = 500
    response_object[:response]   = ""
    response_object[:message]    = "The server encountered an unexpected condition which prevented it from fulfilling the request"
    return response_object
  end
  
  def update_courses
    courses = Course.all
    courses.each do |course|
      DeviceCommunicationController::API_MODULE_MAP[course.api].update(course)
    end
    render :nothing => true
  end
  
  def schedule_mailing(data,eta)
    dump = Dump.create({:data => data.to_json})
    Dump.schedule(eta,dump.id)
    render :nothing => true
    
  end
  
  def perform_reminder
    dump = Dump.find(params[:key].to_i)
    ConfirmMailer.deliver_reminder(dump)
  end
  
  def test_schedule
    data = {"f_name"=>"Arjun","l_name"=>"Vasan","email"=>"arjun.vasan@gmail.com"}
    eta_day = "2012-02-01"
    eta_time = "13:00"
    dump = Dump.create({:data => data.to_json})
    #Dump.schedule(eta,dump.id)
    query = "/schedule/perform_reminder?key=#{dump.id.to_s}&d=#{eta_day}&t=#{eta_time}"
    
    url = URI.parse("http://dump-them.appspot.com")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = false
    headers = {}

    response = http.get(query, headers)
    
    render :nothing => true
    #schedule_mailing(data,eta)

  end
  
  
end
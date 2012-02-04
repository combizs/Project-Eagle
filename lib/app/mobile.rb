require 'pp'
require 'json'
require 'apns'
require 'xmlsimple'
require 'date'
require 'lib/api/fore.rb'

class MobileApp
  attr_accessor :course, :time, :golfers, :date, :params, :d2, :d, :times, :ampm, :request, :user, :total, :reservations
  def initialize(params,request,session)
    @course = Course.find(params[:course_id].to_i)
    if params[:time].nil?
      params[:time] = ""
    end
    if params[:date].nil?
      params[:date] = Date.today.strftime("%Y-%m-%d")
    end
    
    @time = params[:time]
    @ampm = Time.parse(@time).strftime("%p")
    @golfers = params[:golfers]
    @date = params[:date]
    @params = params
    @request = request
    
    @reservations = []
    
    begin
      @total = (params[:golfers].to_i * params[:price].to_i).to_s
    rescue
      @total = ""
    end
    
    
    @user ||= session[:current_user_id] && User.find_by_id(session[:current_user_id])
    
    if !@user.nil?
      @reservations = Reservation.find_all_by_user_id_and_course_id_and_status_code(@user.id.to_s,@course.id,Reservation::BOOKING_SUCCESS_STATUS_CODE,:order=>"date DESC,time DESC")
    end
    
    today = Date.today
    
    @d2 = (0..6).map {|x| (today+x).strftime("%A, %B %e")}
    @d = (0..6).map {|x| (today+x).strftime("%Y-%m-%d")}
    
    begin
      dates = JSON.parse(@course.available_times)
      @times = dates[params[:date]]["day"]
    rescue
    end
    
  end
  def prev_date
    return (Date.parse(@date)-1).strftime("%Y-%m-%d")
  end
  def next_date
    return (Date.parse(@date)+1).strftime("%Y-%m-%d")
  end
  def get_user_email
    if !@user.nil? 
      return @user.email
    else
      return ""
    end
  end
  def get_user_fname
    if !@user.nil? 
      return @user.f_name
    else
      return ""
    end
  end
  def get_user_lname
    if !@user.nil? 
      return @user.l_name
    else
      return ""
    end
  end
  def get_query
    kvs = []
    @params.each_pair do |k,v|
      kvs.push(k+"="+v)
    end
    return "?#{kvs.join('&')}"
  end
  
  def course_info
    return JSON.parse(@course.info)
  end
  
  def get_url(action,new_params)
    @params = @params.merge(new_params)
    uri = "/mobile/#{action}#{get_query}"
  end
  
  def is_active(act)
    uri = @request.url.split("/")[-1].split("?")[0]
    if uri == act
      return true
    else
      return false
    end
  end
  
  
end
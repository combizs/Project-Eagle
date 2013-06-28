require 'pp'
require 'json'
require 'apns'
require 'xmlsimple'
require 'date'
require './lib/api/fore.rb'
require './lib/app/mobile.rb'

# This is the controller for the mobile web app version that allows tee time bookings
# Below is the expected format for paramters received from all client devices

# ==========================================
# = DEFINE STANDARD PARAMETER FORMATS ======
# ==========================================

# course_id           => '1'                      (String, Required)   
# golfers             => '2'                      (String)   
# time                => '07:14'                  (String)   
# date                => '2011-05-11'             (String)
# f_name              => 'first_name'             (String)
# l_name              => 'last_name'              (String)
# email               => 'name@domain.com'        (String)

# ==========================================
# =========== Controller Actions ===========
# ==========================================

# booking             => '/mobile/booking'        (This is the main page of the booking expereince, wihich contains the Golfers, Date, Tee Time, ANd Book Reservation button)
# golfer_select       => '/mobile/num'            (Select between 2,3,4 golfers)
# date_select         => '/mobile/date'           (Select the date)
# time_select         => '/mobile/time'           (Select the tee time you want to play)
# reservations        => '/mobile/reservations'   (View previous/upcoming reservations as well as account details)
# view reservation    => '/mobile/view'           (View details aout a specific reservation)
# about us            => '/mobile/about'          (View all course information) 

class MobileController < ApplicationController
  
  before_filter :get_mobile_app
  skip_before_filter :verify_authenticity_token 

  # http://m.playdeepcliff.com/ is the same as http://www.presstee.com/mobile/?course_id=1
  # http://localhost:3000?course_id=1 (To access via localhost) 
  # http://localhost:3000/mobile?course_id=1 will not work in localhost becasue it's routing to a method called def mobile which doesnt exist, this routing is used to make sure the course subdomains are handled correctly, but it breaks things on localhost
  
  def get_mobile_app                                                        # Render the company landing page shows course info and 'Book Tee Time' button
    mdomain = request.url.sub("http://","").split("/")[0]                   # Render the appropriate mobile booking experience depending on course domain
    if mdomain == 'pric.io' or params[:pricio] == "true"                    # For example, m.playdeepcliff.com will look up course by domain "http://m.playdeepcliff.com"
      render :template => "web/pricio"                                      # This method is run before any other method b/c of before_filter defined above      
    else                                                                    
      course = Course.find_by_mobile_domain(mdomain)                        
      params[:course_id] = course.id.to_s if !course.nil?  
      params[:course_id] = 1 if Rails.env.to_s =="development"
  
      @app = MobileApp.new(params,request,session,cookies)          
    end
  end
  
  def confirm
    dog = "nothing"
  end
  
  # http://localhost:3000/booking?course_id=1
  # http://m.playdeepcliff.com/booking
  def booking
    puts "-------------------------Here are the cookie / session details:"
    pp cookies[:current_user_id]
    pp session[:current_user_id] 
    pp @app.user
    puts "---------------------------------------------------------------"
  end
  
  # This is the landing page experience for all courses
  # Users can see general course info, and the primary call to action here is to 'Book Tee Time'
  # 'Book Tee Time' routes user to /booking view page
  def index
  end

  def view
    @email = "test this sht"
    puts "-------------------------VIEW-------------------------" 
    puts @app.user.email
    puts @email
    puts "-------------------------END-VIEW-------------------------" 
  end
  
  def time
    @discount = Course::DISCOUNTED_PRICING
  end  
  
  def book
  end

  def charges
        puts "-------------------------CHARGES-------------------------" 

    @app.user
  end
  
  def more_days
    @app.more_days(params[:last])
  end 
 
  # If the user_agent contains any part of this regex, it will valifdate to true
  # For example, if the user_agent has the word 'Mobile' it will validate to true
  def mobile_agent?
    request.user_agent =~ /Mobile|webOS/
  end
  def ipad?
    request.user_agent =~ /iPad/
  end
  def android?
    request.user_agent =~ /Android/
  end
  def blackberry?
    request.user_agent =~ /BlackBerry/
  end
  def windows?
    request.user_agent =~ /Windows/
  end
  def symbian?
    request.user_agent =~ /Symbian/
  end
  def iframe
    # Example iframe snippet that's pasted on 3rd party site
    # Since get_mobile_app is run before this method, the course_id param is pulled from the iframe request
    # <iframe style="width: 0px; height: 0px; border: 0px; display: none;" src="http://www.presstee.com/mobile/iframe?course_id=2" width="0px" height="0px"></iframe>
    @is_mobile = mobile_agent?
    @is_ipad   = ipad?
    @request   = request
  end
  
end

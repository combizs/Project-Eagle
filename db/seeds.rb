# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

u = User.new
u.email = 'carlcwheatey@gmail.com'
u.f_name = 'Carl'
u.l_name = 'Wheatley'
u.device_name = 'iPhone'
u.os_version = '5.0'
u.app_version = '1.0'

if !u.save
  puts 'user seed failed!'
end


c = Course.new
c.name = "Deep Cliff"
c.api = "fore"
c.api_course_id = "1987654"
c.fee_matrix = {
  "split" => [14,16],
  "holidays" => [1,360],
  "public" => {
    "weekday" => [28,21,18],
    "weekend" => [38,28,22]},
  "member" => {
    "weekday" => [21,17,15],
    "weekend" => [31,22,17]}
}.to_json

c.info = {
  "title_short" => "Deep Cliff",
  "title" => "Deep Cliff Golf Course",
  "url" => "http://www.playdeepcliff.com/",
  "phone" => "(408) 253-5357",
  "address" => {
    "city" => "Cupertino",
    "state" => "CA",
    "street" => "10700 Club House Ln",
    "logo" => "",
    "gallery" => ["/images/holes/hole1.png","/images/holes/hole2.png","/images/holes/hole3.png","/images/holes/hole4.png","/images/holes/hole5.png","/images/holes/hole5.png","/images/holes/hole6.png","/images/holes/hole7.png","/images/holes/hole8.png","/images/holes/hole9.png","/images/holes/hole10.png","/images/holes/hole11.png","/images/holes/hole12.png","/images/holes/hole13.png","/images/holes/hole14.png","/images/holes/hole15.png","/images/holes/hole16.png","/images/holes/hole17.png","/images/holes/hole18.png"]
  }
}.to_json
c.mobile_domain = "http://m.deepclifftv.com/"
c.web_domain = "http://www.deepclifftv.com/"
c.save
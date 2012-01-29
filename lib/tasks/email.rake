desc "Fetch all Email Reservation records rom db, update them in the Reservation table, then delete each record"
task :update_email_reservations => :environment do
  emails = EmailReservation.all
  ctr=0
  emails = User.find_each(:select => "date, time, golfers, course_id") do |email|
    r = Reservation.find_by_date_and_time_and_golfers(email.date,email.time,email.golfers)
    if r
      r.update_attributes :booking_type => 'email' 
      ctr = ctr + 1
    end
    email.destroy
  end
  
  puts "Done!  Successfully updated the booking type for #{ctr} reservation records."
end
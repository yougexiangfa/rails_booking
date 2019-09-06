module RailsBooking::Booker
  extend ActiveSupport::Concern

  included do
    has_many :booker_times, class_name: 'TimeBooking', as: :booker
  end
  
  
  def confirm_booker_time!(booked)
    p 'implement in application'
  end

end
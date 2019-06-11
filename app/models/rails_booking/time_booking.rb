module RailsBooking::TimeBooking
  extend ActiveSupport::Concern
  included do
    attribute :booking_on, :date
    
    belongs_to :booker, polymorphic: true
    belongs_to :booked, polymorphic: true, optional: true
    belongs_to :plan_item, optional: true
    belongs_to :time_item
    belongs_to :time_list
  
    delegate :start_at, :finish_at, to: :plan_item, allow_nil: true
    
    validates :booker_id, uniqueness: { scope: [:booker_type, :plan_item_id] }
    
    before_validation :sync_time_list_id
    after_create :sync_to_booker
  end
  
  def sync_time_list_id
    if plan_item
      self.booked_type = self.plan_item.plan_type
      self.booked_id = self.plan_item.plan_id
      self.time_item_id = self.plan_item.time_item_id
      self.time_list_id = self.time_item.time_list_id
    end
  end
  
  def sync_to_booker
    booker.confirm_booker_time!(self)
  end

end

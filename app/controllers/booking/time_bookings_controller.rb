class Booking::TimeBookingsController < Booking::BaseController
  before_action :set_plan_item
  before_action :set_time_booking, only: [:show, :destroy]

  def index
    q_params = {
    }
    q_params.merge! params.permit(:booker_type, :booker_id)
    @time_bookings = @plan_item.time_bookings.default_where(q_params).page(params[:page])
  end

  def new
    @time_booking = @plan_item.time_bookings.build
  end

  def create
    @time_booking = @plan_item.time_bookings.find_or_initialize_by(booker_type: params[:booker_type], booker_id: params[:booker_id])

    respond_to do |format|
      if @time_booking.save
        format.html.phone
        format.html { redirect_to booking_time_bookings_url }
        format.js { redirect_back fallback_location: booking_time_bookings_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: booking_time_bookings_url }
        format.json { render :show }
      end
    end
  end
  
  def show
  end

  def destroy
    @time_booking.destroy
    redirect_to booking_time_bookings_url
  end

  private
  def set_plan_item
    @plan_item = PlanItem.find params[:plan_item_id]
  end
  
  def set_time_booking
    @time_booking = @plan_item.time_bookings.find(params[:id])
  end
  
end

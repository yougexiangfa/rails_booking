module Eventual
  class Admin::PlanItemsController < Admin::BaseController
    before_action :set_plan_item, only: [:show, :edit, :update, :qrcode, :destroy]

    def index
      q_params = {}
      filter_params = {
        start_on: Date.today.beginning_of_week,
        finish_on: Date.today.end_of_week
      }.with_indifferent_access
      filter_params.merge! params.permit(:start_on, :finish_on)
      filter_params.merge! default_params

      q_params.merge! params.permit(:planned_type, :planned_id, :place_id, 'plan_participants.event_participant_id')

      @plans = Plan.xxx(**filter_params.symbolize_keys)
      @plans.each { |plan| plan.produce(start_on: filter_params[:start_on], finish_on: filter_params[:finish_on]) }

      @plan_items = PlanItem.to_events(**filter_params.symbolize_keys)

      booking_params = {
        booker_type: 'Maintain',
        booker_id: params[:maintain_id],
        'booking_on-gte': filter_params[:start_on],
        'booking_on-lte': filter_params[:finish_on]
      }

      @booked_ids = Booking.default_where(booking_params).pluck(:plan_item_id)
    end

    def new
      @plan_item = PlanItem.new
    end

    def create
      @plan_item = PlanItem.new(plan_item_params)

      unless @plan_item.save
        render :new, locals: { model: @plan_item }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
      @places = Place.default_where(default_params)
    end

    def update
      @plan_item.assign_attributes(plan_item_params)

      unless @plan_item.save
        render :edit, locals: { model: @plan_item }, status: :unprocessable_entity
      end
    end

    def qrcode
      @plan_item.qrcode
    end

    def destroy
      @plan_item.destroy
    end

    private
    def set_plan_item
      @plan_item = PlanItem.find(params[:id])
    end

    def plan_item_params
      params.fetch(:plan_item, {}).permit(
        :planned_type,
        :planned_id,
        :plan_on,
        :time_item_id,
        :event_item_id,
        :place_id,
        plan_participants_attributes: [:participant_type, :participant_id]
      )
    end

  end
end

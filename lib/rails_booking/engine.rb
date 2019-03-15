module RailsBooking
  class Engine < ::Rails::Engine
    config.eager_load_paths += Dir["#{config.root}/app/models/rails_booking"]
    config.eager_load_paths += Dir["#{config.root}/app/models/rails_booking/concerns"]

  end
end
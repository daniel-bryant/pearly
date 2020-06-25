require_dependency "pearly/authenticatable"

module Pearly
  class Engine < ::Rails::Engine
    isolate_namespace Pearly

    ActiveSupport.on_load(:action_controller_api) { include Pearly::Authenticatable }
  end
end

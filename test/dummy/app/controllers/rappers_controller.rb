class RappersController < ActionController::API
  def index
    render json: [{ name: "Gunna" }]
  end
end

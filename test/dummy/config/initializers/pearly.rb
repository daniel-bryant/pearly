Pearly.configure do |config|
  config.on_authenticate do |username, password|
    User.authenticate(username, password)
  end

  config.on_validate_client do |client_id, client_secret|
    Pearly.secure_validate(client_id, client_secret, {
      "sample client" => "rubber ducks"
    })
  end
end

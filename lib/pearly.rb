require "pearly/engine"

module Pearly
  def self.configure
    yield self
  end

  def self.on_authenticate(&block)
    @authenticate = block
  end

  def self.authenticate
    @authenticate
  end

  def self.on_validate_client(&block)
    @validate_client = block
  end

  def self.validate_client
    @validate_client
  end

  def self.secure_validate(id, secret, clients)
    clients.has_key?(id) && ActiveSupport::SecurityUtils.secure_compare(clients[id], secret)
  end
end

class User
  attr_reader :id

  def self.authenticate(username, password)
    if username == "jojo" && password == "prettyplease"
      User.new
    end
  end

  def initialize
    @id = 1
  end
end

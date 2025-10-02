class Author
  attr_reader :name, :email

  def initialize(name, email)
    raise ArgumentError, "Name cannot be empty"  if name.to_s.strip.empty?
    raise ArgumentError, "Email cannot be empty" if email.to_s.strip.empty?
    raise ArgumentError, "Invalid email format"  unless email.to_s.include?("@")
    @name  = name
    @email = email
  end
end

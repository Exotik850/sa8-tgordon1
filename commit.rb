require "digest"
class Commit
  attr_reader :id, :message, :author, :timestamp, :parent

  def initialize(message:, author:, parent:, timestamp: Time.now)
    raise ArgumentError, "Message cannot be empty" if message.to_s.strip.empty?
    raise ArgumentError, "Author required"          if author.nil?

    @message   = message
    @author    = author
    @parent    = parent       # Commit or nil (root)
    @timestamp = timestamp
    @id        = compute_id   # 12 character string
  end

  private

  # private methods should not be tested directly
  def compute_id
    payload = [
      message,
      author.email,
      timestamp.utc,
      parent&.id.to_s
    ].join("\n")
    Digest::SHA1.hexdigest(payload)[0, 12]
  end
end

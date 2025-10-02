require "author"

RSpec.describe Author do
  let (:name) { "Bajungs" }
  let (:email) { "bajungs@yahoo.com" }
  describe ".new" do
    it "should error on empty email" do
      expect {
        Author.new(name, "")
      }.to raise_error(ArgumentError)
    end

    it "should error on incorrect email" do
      expect {
        Author.new(name, "bajuns.yahoo.com")
      }.to raise_error(ArgumentError)
    end

    it "should error on empty name" do
      expect {
        Author.new("", email)
      }.to raise_error(ArgumentError)
    end

    it "should accept valid emails and non-empty names" do
      expect {
        Author.new(name, email)
      }.not_to raise_error
    end
  end
end

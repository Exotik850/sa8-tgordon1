require "commit"
require "author"

RSpec.describe Commit do
  let(:author) { Author.new("Tom", "tomhanks@gmail.com") }
  let(:message) { "Something" }

  describe ".new" do
    it "should error on empty message" do
      expect {
        Commit.new(message: "", author:, parent: nil)
      }.to raise_error(ArgumentError)
    end
    it "should error on missing author" do
      expect {
        Commit.new(message:, author: nil, parent: nil)
      }.to raise_error(ArgumentError)
    end
    it "should accept non-empty messages and a valid author" do
      expect {
        Commit.new(message:, author:, parent: nil)
      }.not_to raise_error
    end
  end
end

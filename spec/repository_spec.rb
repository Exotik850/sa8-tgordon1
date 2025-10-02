require "repository"
require "author"
require "commit"

# Define the custom error used by Repository if not already defined
class BranchNotFound < StandardError; end unless defined?(BranchNotFound)

RSpec.describe Repository do
  let(:repo) { Repository.new }
  let(:author) { Author.new("Jane", "jane@example.com") }

  describe ".new" do
    it "initializes with a main branch and no commits" do
      expect(repo.current_branch).to eq("main")
      expect(repo.branches).to eq({ "main" => nil })
      expect(repo.log).to eq([])
    end
  end

  describe ".create_branch" do
    it "errors on empty branch name" do
      expect { repo.create_branch("") }.to raise_error(ArgumentError)
    end

    it "errors when branch already exists" do
      expect { repo.create_branch("main") }.to raise_error(ArgumentError)
    end

    it "creates a new branch pointing at current head (nil if no commits)" do
      repo.create_branch("feature")
      expect(repo.branches.keys).to include("feature")
      expect(repo.branch("feature")).to be_nil
    end

    it "new branch points at the same head commit as current branch" do
      head = repo.commit!(message: "init", author: author)
      repo.create_branch("feature")
      expect(repo.branch("feature")).to eq(head.id)
      expect(repo.branch("main")).to eq(head.id)
    end
  end

  describe ".branch" do
    it "errors when branch does not exist" do
      expect { repo.branch("nope") }.to raise_error(BranchNotFound)
    end

    it "returns the head commit id for an existing branch" do
      c1 = repo.commit!(message: "c1", author: author)
      expect(repo.branch("main")).to eq(c1.id)
    end
  end

  describe ".switch" do
    it "errors when switching to a non-existent branch" do
      expect { repo.switch("dev") }.to raise_error(BranchNotFound)
    end

    it "switches current_branch when the branch exists" do
      repo.create_branch("feature")
      repo.switch("feature")
      expect(repo.current_branch).to eq("feature")
    end

    it "commits after switching only advance the switched branch" do
      main_commit = repo.commit!(message: "m1", author: author)
      repo.create_branch("feature")
      repo.switch("feature")
      feat_commit = repo.commit!(message: "f1", author: author)

      expect(repo.branch("feature")).to eq(feat_commit.id)
      expect(repo.branch("main")).to eq(main_commit.id)
    end
  end

  describe ".log" do
    it "returns an empty array for a branch with no commits" do
      expect(repo.log("main")).to eq([])
    end

    it "returns commits from newest to oldest following parent links" do
      c1 = repo.commit!(message: "first", author: author)
      c2 = repo.commit!(message: "second", author: author)

      log = repo.log("main")
      expect(log.map(&:class)).to all(eq(Commit))
      expect(log.size).to eq(2)
      expect(log.first.id).to eq(c2.id)
      expect(log.last.id).to eq(c1.id)
    end
  end

  describe ".commit" do
    it "errors on empty commit message" do
      expect { repo.commit!(message: "", author: author) }.to raise_error(ArgumentError)
    end

    it "errors on missing author" do
      expect { repo.commit!(message: "ok", author: nil) }.to raise_error(ArgumentError)
    end

    it "creates a commit, advances head, and links parent" do
      c1 = repo.commit!(message: "one", author: author)
      expect(c1).to be_a(Commit)
      expect(c1.id).to be_a(String)
      expect(c1.id.length).to eq(12)
      expect(repo.branch("main")).to eq(c1.id)

      c2 = repo.commit!(message: "two", author: author)
      expect(repo.branch("main")).to eq(c2.id)
      expect(c2.parent).to eq(c1)
    end
  end
end

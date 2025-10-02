class Repository
  attr_reader :name, :branches, :current_branch

  def initialize
    @commits         = {}                 # commit_id => Commit
    @branches        = { "main" => nil }  # branch_name (String) => head_commit_id (or nil)
    @current_branch  = "main"
  end

  def create_branch(name)
    raise ArgumentError, "Branch name cannot be empty" if name.to_s.strip.empty?
    raise ArgumentError, "Branch '#{name}' already exists" if @branches.key?(name)

    @branches[name] = @branches[@current_branch] # copy head commit id pointer
  end

  def branch(name)
    raise BranchNotFound, "No such branch '#{name}'" unless @branches.key?(name)

    @branches[name] # returns commit_id (could be nil)
  end

  def switch(branch_name)
    raise BranchNotFound, "No such branch '#{branch_name}'" unless @branches.key?(branch_name)

    @current_branch = branch_name
  end

  # Follow parent links from the branch's head commit id and return Commit objects (newest → oldest)
  def log(branch_name = current_branch)
    head_id = branch(branch_name)
    out = []
    c = head_id && @commits[head_id]
    while c
      out << c
      c = c.parent
    end
    out
  end

  def commit!(message:, author:)
    parent_commit = @commits[@branches[@current_branch]]
    commit = Commit.new(
      message: message,
      author: author,
      parent: parent_commit
    )

    # advance branch head and index commit
    @branches[@current_branch] = commit.id
    @commits[commit.id] = commit
    commit
  end
end

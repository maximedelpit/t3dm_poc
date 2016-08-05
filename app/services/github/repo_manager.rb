# https://github.com/jollygoodcode/jollygoodcode.github.io/issues/14
# http://www.gitguys.com/topics/git-object-tag/
class RepoManager
  require "base64" # Github file encoded in base64

  def initialize(user_id, project_id)
    @user = User.find(user_id)
    @octokit_client = Octokit::Client.new(:access_token => @user.token)
    @project = Project.find(project_id)
  end

  def generate_full_repo
    create_repo
    new_commit = create_commit("master", create_tree_repo_architecture, "Create repo architecture")
    add_commit_to_branch("master", new_commit)
  end

  private

  def create_repo
    # Create a repo with initial commit and master branch
    begin
      repository = @octokit_client.create_repository(@project.repo_name,
        description: @project.purpose.title,
        private: true,
        auto_init: true
      )
    rescue Octokit::Response::RaiseError => e
      puts "Mayday! Mayday!"
      e.errors.each {|error| puts "#{error[:resource]} - #{error[:message]}" }
    end
  end

  def create_branch(base_branch, new_branch)
    base_branch_sha = get_branch_ref_sha(base_branch)
    @octokit_client.create_ref(
      @project.repo_uri,
      "heads/#{new_branch_name}",
      base_branch_sha
    )
  end

  def create_tree_repo_architecture
    @octokit_client.create_tree(@project.repo_uri, repo_basic_architecture)
  end

  def repo_basic_architecture
    directories = ["3D Models","2D Plans", "Specs", "Commercial Proposition", "Quality Control", "Shipment", "Defaults", "Suppliers"]
    trees = []
    directories.each do |dir_name|
      trees << { path: dir_name, mode:"040000", type: "tree", sha: get_branch_tree_sha("master")  }
    end
    return trees
  end

  def create_commit(branch_name, new_tree, message)
    commit = @octokit_client.git_commit(@project.repo_uri, get_branch_ref_sha(branch_name))
    @octokit_client.create_commit(@project.repo_uri, message, new_tree[:sha], commit[:sha])
  end

  def add_commit_to_branch(branch_name, new_commit)
    @octokit_client.update_ref(@project.repo_uri, "heads/#{branch_name}", new_commit[:sha])
  end

  def create_pull_request(head_branch, base_branch, title, body)
    # base_branch => branch on which to merge i.e master
    # head_branch => branch on which modif has been made i.e new branch commit
    @octokit_client.create_pull_request(@project.repo_uri, base_branch, head_branch, title, body)
  end

  # Get all contents
  # @octokit_client.contents(owner:@project.github_owner, repo:@project.repo_name)

  def get_file_content(file_path, base_branch)
    repo_uri = @project.repo_uri
  end


  ############ Retrieve info  based on branch name && sha ############

  def get_branch(branch_name)
    return @octokit_client.branch(@project.repo_uri, branch_name)
  end

  def get_branch_ref_sha(branch_name)
    # branch = @octokit_client.refs(@project.repo_uri).find do |reference|
    #   "refs/heads/#{branch_name}" == reference.ref
    # end
    # return branch.object.sha
    return get_branch(branch_name)[:commit][:sha]
  end

  def get_branch_tree_sha(branch_name)
    return get_branch(branch_name)[:commit][:commit][:tree][:sha]
  end
end




# https://github.com/jollygoodcode/jollygoodcode.github.io/issues/14
# http://www.gitguys.com/topics/git-object-tag/
# http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/
class RepoManager
  require "base64" # Github file encoded in base64

  def initialize(user_id, project_id, file_path = nil, file_name = nil)
    @user = User.find(user_id)
    @octokit_client = Octokit::Client.new(:access_token => @user.token)
    @project = Project.find(project_id)
    @file_path = file_path
    @file_name = file_name
  end

  def generate_full_repo
    create_repo
    new_commit = create_commit("master", create_tree_repo_architecture, "Create repo architecture")
    add_commit_to_branch("master", new_commit)
  end

  private

  def create_branch(base_branch, new_branch)
    base_branch_sha = get_branch_ref_sha(base_branch)
    @octokit_client.create_ref(
      @project.repo_uri,
      "heads/#{new_branch_name}",
      base_branch_sha
    )
  end

  def create_repo
    # Create a repo with initial commit and master branch
    begin
      repository = @octokit_client.create_repository(@project.repo_name,
        private: false,
        auto_init: true
      )
      @project.update(repo_id: repository.id)
    rescue Octokit::Response::RaiseError => e
      puts "Mayday! Mayday!"
      e.errors.each {|error| puts "#{error[:resource]} - #{error[:message]}" }
    end
  end

  def create_tree_repo_architecture
    return @octokit_client.create_tree(@project.repo_uri, repo_basic_architecture)
  end

  def repo_basic_architecture
    directories = ["3D Models", "2D Plans", "Specs", "Commercial Proposition", "Quality Control", "Shipment", "Defaults", "Suppliers"]
    trees = []
    directories.each do |dir_name|
      trees << { path: dir_name, mode:"040000", type: "tree", sha: get_branch_ref_tree_sha("master")  }
      if dir_name == "3D Models" && !@file_path.nil?
        trees << add_folder_with_file(dir_name, @file_path, @file_name, "master")
      end
    end
    return trees
  end

  def add_folder_with_file(dir_path, file_path, file_name, head_branch)
    # 1) get branch last commit base tree sha
    sha_branch_base_tree = get_branch_ref_tree_sha(head_branch)
    # 2) define filename
    github_path = "#{dir_path}/#{file_name}"
    # 3) create a blob (file) and store sha
    file_content = File.open(file_path).read
    base64_file_content = Base64.encode64(file_content)
    if base64_file_content.valid_encoding?
      blob_sha = @octokit_client.create_blob(@project.repo_uri, base64_file_content, "base64")
      # 4) create a tree to integrate new blob => base_tree option will replace content of former tree (I think)
      new_blob_tree = { :path => github_path,
                   :mode => "100644",
                   :type => "blob",
                   :sha => blob_sha
                 }
      return new_blob_tree
    else
      raise
    end
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


  ############ Retrieve info  based on branch name && sha ############

  def get_branch_ref(branch_name)
    return @octokit_client.ref(@project.repo_uri, "heads/#{branch_name}")
  end

  def get_branch_ref_sha(branch_name)
    return get_branch_ref(branch_name).object.sha
  end

  def get_branch_ref_tree_sha(branch_name)
    # the tree last commit of the branch point to
    return @octokit_client.commit(@project.repo_uri, get_branch_ref_sha(branch_name)).commit.tree.sha
  end
end



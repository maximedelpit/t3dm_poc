# https://github.com/jollygoodcode/jollygoodcode.github.io/issues/14
# http://www.gitguys.com/topics/git-object-tag/
# http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/
class RepoManager
  # TO DO REFACT & manage errors seb like
  require "base64" # Github file encoded in base64
  require 'digest/sha1'
  include Cache

  def initialize(user_id, project_id, options= {})
    @user = User.find(user_id)
    @octokit_client = Octokit::Client.new(:access_token => @user.token)
    @project = Project.find(project_id)
    @file_path = options[:file_path]
    @file_name = options[:file_name]
  end

  def generate_full_repo
    create_repo
    new_commit = create_repo_architecture_commit("master", create_tree_repo_architecture, "Create repo architecture")
    add_commit_to_branch("master", new_commit)
  end

  ############ Retrieve info  based on branch name && sha ############
  def retrieve_repo_architecture(branch_name)
    # TO DO cache
    tree_sha = get_branch_ref_tree_sha(branch_name)
    repo_tree = from_cache(@project.id, @project.repo_uri, branch_name, tree_sha, "structure") do
      response = @octokit_client.tree(@project.repo_uri, tree_sha, recursive: true)
    end
    return arrange_tree(flat_structure(repo_tree[:tree]))
  end

  def upload_file(base_branch_name, dir_path, options={})
    # NB check if we need to make diff between new and update
    # What was the point of the versionning discussion with benjamin ? => last commit date?
    # TO DO: when treating direct & team => include it in message
    if options[:new_branch]
      head_branch = create_branch(base_branch_name, options[:new_branch])
      head_branch_name = head_branch[:ref].split('/').last
    else
      head_branch_name = base_branch_name
    end
    blob = add_file_to_folder(dir_path, @file_path, @file_name, head_branch_name)
    commit = @octokit_client.git_commit(@project.repo_uri, get_branch_ref_sha(head_branch_name))
    new_tree = @octokit_client.create_tree(@project.repo_uri, [blob], {base_tree: commit[:tree][:sha]})
    new_commit = create_repo_architecture_commit(head_branch_name, new_tree, "Upload #{@filename} in #{dir_path}")
    add_commit_to_branch(head_branch_name, new_commit)
    create_pull_request(base_branch_name, head_branch_name, options[:pr_title], options[:pr_body]) if options[:pr]
  end
  #Get a content blob
    # @octokit_client.contents(@project.repo_uri, path:"3D Models/0_index_projet_list.jpg", sha: "84bb468c935ea2032d2dff95c02a4e7970f0fd10")



  private

  def create_branch(base_branch, new_branch)
    base_branch_sha = get_branch_ref_sha(base_branch)
    @octokit_client.create_ref(@project.repo_uri, "heads/#{new_branch}", base_branch_sha)
  end

  def create_repo
    # Create a repo with initial commit and master branch
    begin
      repository = @octokit_client.create_repository(@project.repo_name,
        private: false,
        auto_init: true
      )
      create_webhook
      @project.update(repo_id: repository.id)
    rescue Octokit::Response::RaiseError => e
      puts "Mayday! Mayday!"
      e.errors.each {|error| puts "#{error[:resource]} - #{error[:message]}" }
    end
  end

  def create_webhook
    whook_url = ENV['HOST'] +"projects/#{@project.id}/github_webhooks"
    config = { url: whook_url, content_type: 'json', secret: ENV['GITHUB_WEBHOOK_SECRET'] }
    options = { :events => ['push', 'pull_request', 'repository'], :active => true }
    @octokit_client.create_hook(@project.repo_uri, 'web', config, options)
  end

  def create_tree_repo_architecture(base_tree = nil)
     return @octokit_client.create_tree(@project.repo_uri, repo_basic_architecture, {base_tree: base_tree})
  end

  def repo_basic_architecture
    directories = ["3D Models", "2D Plans", "Specs", "Commercial Proposition", "Quality Control", "Shipment", "Defaults", "Suppliers"]
    trees = []
    directories.each do |dir_name|
      # trees << { path: dir_name, mode:"040000", type: "tree", sha: get_branch_ref_tree_sha("master")  }
      if dir_name == "3D Models" && !@file_path.nil?
        trees << add_file_to_folder(dir_name, @file_path, @file_name, "master")
      else
        trees << add_file_to_folder(dir_name, nil, "#{dir_name}.txt", "master", "Use this folder for #{dir_name} items")
      end
    end
    return trees
  end

  # def generate_git_sha(object_type, object_content = "")
  #   # https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
  #   header = "#{object_type} #{content.length}\0"
  #   store = header + content
  #   sha1 = Digest::SHA1.hexdigest(store)
  # end

  def add_file_to_folder(dir_path, file_path, file_name, head_branch_name, file_content = nil)
    # 1) get branch last commit base tree sha
    sha_branch_base_tree = get_branch_ref_tree_sha(head_branch_name)
    # 2) define filename
    github_path = "#{dir_path}/#{file_name}"
    # 3) create a blob (file) and store sha
    file_content ||= File.open(file_path).read
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

  def create_repo_architecture_commit(branch_name, new_tree, message)
    # Must be improved since structure_tree is created before commit... (since no blob anyway...)
    commit = @octokit_client.git_commit(@project.repo_uri, get_branch_ref_sha(branch_name))
    @octokit_client.create_commit(@project.repo_uri, message, new_tree[:sha], commit[:sha])
  end

  def add_commit_to_branch(branch_name, new_commit)
    @octokit_client.update_ref(@project.repo_uri, "heads/#{branch_name}", new_commit[:sha])
  end

  def create_pull_request(base_branch_name, head_branch_name, title, body)
    # base_branch => branch on which to merge i.e master
    # head_branch => branch on which modif has been made i.e new branch commit
    @octokit_client.create_pull_request(@project.repo_uri, base_branch_name, head_branch_name, title, body)
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

  ############ Treatement of github tree to transform within tree js structure ############
  def flat_structure(repo_tree)
    # Used to add ancestry within github main tree
    # We sort them by path
    # maybe use sha for ancestry items ?
    repo_tree.sort_by do |item|
      split_path = item.path.split('/')
      item[:id] = item.sha
      item[:name] = split_path.last
      item[:ancestry] = split_path.select {|v| v != item[:name]}.join('/')
      item[:ancestry] = nil if item[:ancestry].empty?
      item[:parent] = split_path[-2]
      item.type == 'tree' ? item[:extension] = 'folder' : item[:extension] = 'file'
      # split_path.length == 1 ? item[:node] = item[:id] : item[:node] = split_path[-2]
      item.path
    end
  end

  def arrange_tree(ancestry_repo_tree)
    tree_by_type = ancestry_repo_tree.group_by(&:type)
    tree_hash = build_tree_architecture(tree_by_type['tree'])
    return fill_with_blobs(tree_hash, tree_by_type['blob'])
  end

  def build_tree_architecture(trees)
    tree_hash = {}
    trees.each do | tree |
      tree[:path].split('/').reduce(tree_hash) do |m,k|
        parent = m.keys.find {|parent| parent.name == k}
        parent ||= tree
        # m.merge!(parent =>  {}) && m = m[parent]
        m.merge!(parent =>  {}) do |key, oldval, newval|
          if m[key] != newval
            oldval
          elsif oldval == {}
            newval
          else
            "pas vu pas pris"
          end
        end
        m = m[parent]
      end
    end
    return tree_hash
  end

  def fill_with_blobs(tree_hash, blobs)
    blobs.each do | blob |
      blob[:path].split('/').reduce(tree_hash) do | m, k |
        if k == blob.name
          m.merge!(blob => {})
        else
          parent = m.keys.find {|parent| parent.name == k }
          # parent ||= tree
          # pas bon
          m = m[parent]
        end
      end
    end
    return tree_hash
  end
end

class ProjectsController < ApplicationController
  before_action :find_project, only: [:edit, :update]
  before_action :project_update_params, only: :update
  def index
    if params[:filters]
      # @projects = current_user.projects.in_phasis(params[:filters])
      @projects = policy_scope(Project).in_phasis(params[:filters])
    else
      # @projects = current_user.projects
      @projects = policy_scope(Project)
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @project = Project.includes(:topics).find(params[:id])
    authorize @project
    mark_notif_as_seen
    @state_machine = @project.state_machine
    @topics = @project.topics
    # when dealing with states & branch
    # @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture(@project.state_machine.current_base_branch)
    @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture("master")
    @topic_hashes = TopicManager.new(current_user.id, @project.id).get_project_topics(@topics)

    if !["adapt_and_finalize", "design_analisys"].include?(@state_machine.current_state)
      @order = @project.last_order || Order.new
    end
  end

  def new
    @project = Project.new
    authorize @project
    build_spec_fields
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    # @project.users.push(current_user)
    # TEMPORARY
    temporary_affect_all_users
    @project.client = current_user.entity
    @project.github_owner = current_user.github_login
    @project.set_default_dimensions # TO DO => rework with stl upload
    @project.thales_id = Project::ExternalInput.next_thales_id
    @project.cycle = 'co-engineering'
    if @project.save
      manage_file_upload
      RepoManager.new(current_user.id, @project, {file_path: @file_path, file_name: @file_name}).generate_full_repo
      # TO DO webhook
      redirect_to project_path(@project)
    else
      build_spec_fields
      render :new
    end
  end

  def edit
  end

  def update
    @project = Project.find(params[:id])
    authorize @project
    # TO DO manage permitted params
    # Make a repository controller
    if params[:upload] == 'true'
      manage_file_upload
      # For the moment no new branch
      RepoManager.new(current_user.id, @project, {file_path: @file_path, file_name: @file_name}).upload_file("master", @dir_path, handle_pull_request)
      @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture("master")
    else
      @project.update(project_params)
    end
    @project.state_machine.next if params[:next] == 'true'
    @project.state_machine.next if params[:previous] == 'true'
    respond_to do |format|
      format.html {redirect_to project_path(@project)}
      format.js {}
    end
  end

  private

   def project_params
    spec_attr = [:id, :title, :description, :_destroy]
    project_params = params.require(:project).permit( :title, :client_project_id, :part_functionality, :notes, :file,
                                     :picture, purpose_attributes: spec_attr, material_attributes: spec_attr,
                                     heat_treatment_attributes: spec_attr, surface_attributes: spec_attr,
                                     dimension_attributes: spec_attr, quality_control_attributes: spec_attr
                                    )
    @file = params[:project][:file]
    project_params.delete(:file)
    return project_params
  end

  def project_update_params
    # #BOURIN +> à investiguer remotipart
    params.permit(:repo, :project, :next, :upload, :previous, :utf8, :_method, :commit, :remotipart_submitted, :authenticity_token, :'X-Requested-With', :'X-Http-Accept', :id)
    if params[:sha]
      params.permit(:sha, :upload, :pull_request, :repo)
      params[:sha].each do |k, v|
        params[:sha].delete(k) if v[:path] == ""
      end
    else
      params.require(:project).permit(:file, :path)
    end
  end

  def find_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def manage_file_upload
    if params[:sha]
      sha_key = params[:sha].keys[0]
      @file = params[:sha][sha_key][:file]
      @dir_path = params[:sha][sha_key][:path]
    else
      @file = params[:project][:file]
      @dir_path = params[:project][:path]
    end
    if @file
      @file_path = @file.tempfile.path
      @file_name = @file.original_filename
    else
      @file_path = nil
      @file_name = nil
    end
  end

  def handle_pull_request
    options = {}
    if params[:pull_request] == 'true'
      options[:new_branch] = "#{@file_name}-#{current_user.name}-#{Time.now.to_i}".gsub(' ','_')
      options[:pr] = true
      options[:pr_title] = params[:repo][:title]
      options[:pr_body] = params[:repo][:content]
    end
    return options
  end

  def build_spec_fields
    # TO DO insert value if params
    @specs = {}
    Spec::TYPE.each do | type |
      type_key = type.underscore.to_sym
      type_attr_key = "#{type.downcase}_attributes"
      if params[:project] && params[:project][type_attr_key]
        value = params[:project][type_attr_key].to_unsafe_h
      else
        value = {}
      end
      @specs[type_key] = instance_variable_set('@' + type.underscore, @project.send('build_' + type.underscore, value))
    end
    return @specs
  end

  def temporary_affect_all_users
    User.all.each {|u| @project.project_users.build(user_id: u.id)}
  end

  def mark_notif_as_seen
    PublicActivity::Activity.where(recipient: current_user, seen: false, trackable_type: 'Project', trackable_id: @project.id).update_all(seen: true)
  end
end

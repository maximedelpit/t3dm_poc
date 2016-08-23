class ProjectsController < ApplicationController
  before_action :find_project, only: [:edit, :update]
  before_action :project_update_params, only: :update
  def index
    if params[:filters]
      @projects = current_user.projects.in_phasis(params[:filters])
    else
      @projects = current_user.projects
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @project = Project.includes(:topics).find(params[:id])
    @topics = @project.topics
    # when dealing with states & branch
    # @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture(@project.state_machine.current_base_branch)
    @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture("master")
    @topic_hashes = TopicManager.new(current_user.id, @project.id).get_project_topics(@topics)
  end

  def new
    @project = Project.new
    build_spec_fields
  end

  def create
    @project = Project.new(project_params)
    @project.users.push(current_user)
    @project.client = current_user.entity
    @project.github_owner = current_user.github_login
    @project.set_default_dimensions # TO DO => rework with stl upload
    @project.thales_id = Project::ExternalInput.next_thales_id
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
    # TO DO manage permitted params
    @project.state_machine.next if params[:next_state]
    @project.state_machine.next if params[:prev_state]
    if params[:upload]

      sha_key = params[:sha].keys[0]
      @file = params[:sha][sha_key][:file]
      manage_file_upload
      dir_path = params[:sha][sha_key][:path]
      # For the moment no new branch
      RepoManager.new(current_user.id, @project, {file_path: @file_path, file_name: @file_name}).upload_file("master", dir_path, handle_pull_request)
    end
  end

  private

   def project_params
    spec_attr = [:id, :title, :description, :_destroy]
    project_params = params.require(:project).permit( :title, :client_project_id, :part_functionality, :notes, :file,
                                     purpose_attributes: spec_attr, material_attributes: spec_attr,
                                     heat_treatment_attributes: spec_attr, surface_attributes: spec_attr,
                                     dimension_attributes: spec_attr, quality_control_attributes: spec_attr
                                    )
    @file = params[:project][:file]
    project_params.delete(:file)
    return project_params
  end

  def project_update_params
    params.permit(:sha, :upload, :pull_request, :repo)
    params[:sha].each do |k, v|
      params[:sha].delete(k) if v[:path] == ""
    end
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def manage_file_upload
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
end

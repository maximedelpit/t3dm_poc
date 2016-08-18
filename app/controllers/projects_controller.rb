class ProjectsController < ApplicationController
  before_action :find_project, except: [:index, :new, :create]
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
    @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture(@project.state_machine.current_base_branch)
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
      if @file
        file_path = @file.tempfile.path
        file_name = @file.original_filename
      else
        file_path = nil
        file_name = nil
      end
      RepoManager.new(current_user.id, @project, {file_path: file_path, file_name: file_name}).generate_full_repo
      # TO DO save repo id
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
    @project.state_machine.next if params[:next_state]
    @project.state_machine.next if params[:prev_state]
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

  def find_project
    @project = Project.find(params[:id])
  end

  # def build_spec_fields
  #   @specs = {}
  #   Spec::TYPE.each do | type |
  #     type_key = type.underscore.to_sym
  #     @specs[type_key] = @project.specs.build(type: type)
  #   end
  #   return @specs
  # end
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

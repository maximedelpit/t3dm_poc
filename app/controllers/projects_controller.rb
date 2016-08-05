class ProjectsController < ApplicationController
  before_action :find_project, except: [:index, :new, :create]
  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @project = Project.new
    build_spec_fields
  end

  def create
    @project = Project.new(project_params)
    @project.client = current_user.entity
    @project.github_owner = current_user.github_login
    @project.state = 'pending' # TO DO state_machine init
    @project.cycle = 'Co-Engineering' # TO DO state_machine init
    @project.set_default_dimensions # TO DO => rework with stl upload
    @project.thales_id = Project::ExternalInput.next_thales_id
    if @project.save
      RepoManager.new(current_user.id, @project).create_repo
    else
      redirect_to :new
    end
  end

  def edit
  end

  def update
  end

  private

   def project_params
    spec_attr = [:id, :title, :description, :_destroy]
    params.require(:project).permit( :title, :client_project_id, :part_functionality, :notes,
                                     purpose_attributes: spec_attr, material_attributes: spec_attr,
                                     heat_treatment_attributes: spec_attr, surface_attributes: spec_attr,
                                     dimension_attributes: spec_attr, quality_control_attributes: spec_attr
                                    )
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
    @specs = {}
    Spec::TYPE.each do | type |
      type_key = type.underscore.to_sym
      @specs[type_key] = instance_variable_set('@' + type.underscore, @project.send('build_' + type.underscore))
    end
    return @specs
  end
end

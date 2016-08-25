class ProjectStatesController < ApplicationController
  before_action :project_state_params, only: :update

  def update
    @project = Project.find(params[:project_id])
    if params[:next]
      @project.state_machine.next
    elsif params[:previous]
      @project.state_machine.previous
    end
  end

  private

  def project_state_params
    params.permit(:next, :previous)
  end
end

class ProjectStatesController < ApplicationController
  before_action :project_state_params, only: :update

  def update
    # TO DELETE
    if params[:user]
      current_user.update(category: params[:user][:category])
    end
    @project = Project.find(params[:project_id])
    @state_machine = @project.state_machine
    params[:user] ? skip_authorization :  authorize(@state_machine)
    if params[:next]
      @project.state_machine.next
    elsif params[:previous]
      @project.state_machine.previous
    end
    @state_machine = @project.state_machine
    get_state_useful_resource
    respond_to do |format|
      format.html {redirect_to project_path(@project)}
      format.js {}
    end
  end

  private

  def project_state_params
    params.permit(:next, :previous, project: [:project_id, :id,], user: [:category])
  end

  def get_state_useful_resource
    case @state_machine.current_state
      when "adapt_and_finalize"
        @order = nil
      when "desing_analysis"
        @order = nil
      when "quotation"
        @order = @project.last_order || Order.new
      else
        @order = @project.last_order
      end
  end
end

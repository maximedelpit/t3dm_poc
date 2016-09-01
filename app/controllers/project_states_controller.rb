class ProjectStatesController < ApplicationController
  before_action :project_state_params, only: :update

  def update
    @project = Project.find(params[:project_id])
    @state_machine = @project.state_machine
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
    params.permit(:next, :previous, project: [:project_id, :id,])
  end

  def get_state_useful_resource
    case @state_machine.current_state
      when "feasibility"
        @meeting = Meeting.where(project_id: @project.id, object: 'Setup').first_or_initialize
        if @meeting.start_time
          @ref_date = @meeting.start_time.to_date.to_s
          @ref_time = @meeting.start_time.to_s(:time)
        end
      when "pricing_estimates"
        @order = @project.last_order || Order.new
      else
        @order = @project.last_order
      end
  end
end

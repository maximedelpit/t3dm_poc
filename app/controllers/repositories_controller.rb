class RepositoriesController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @state_machine = @project.state_machine
    if @state_machine.current_state == 'feasibility'
      @meeting = Meeting.where(project_id: @project.id, object: 'Setup').first_or_initialize
      if @meeting.start_time
        @ref_date = @meeting.start_time.to_date.to_s
        @ref_time = @meeting.start_time.to_s(:time)
      end
    end
    if @state_machine.phasis != "Adapt & Finalize"
      @order = @project.last_order || Order.new
    end
    blob_path = params[:path]
    blob_sha = params[:sha]
    @file = RepoManager.new(current_user, @project.id).get_blob(blob_sha)
    @file[:path] = blob_path
    @file[:extension] = File.extname blob_path
    binding.pry
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
end

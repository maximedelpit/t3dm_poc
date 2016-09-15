class RepositoriesController < ApplicationController
  require "base64"
  def show
    @project = Project.find(params[:id])
    @state_machine = @project.state_machine
    if !["adapt_and_finalize", "design_analisys"].include?(@state_machine.current_state)
      @order = @project.last_order || Order.new
    end
    blob_path = params[:path]
    blob_sha = params[:sha]
    @file = RepoManager.new(current_user, @project.id).get_blob(blob_sha)
    @file[:path] = blob_path
    @file[:extension] = File.extname blob_path
    @file[:basename] = File.basename(blob_path)
    if @file[:extension] == '.stl'
      respond_to do |format|
        format.html {}
        format.js {}
      end
    else
      content_type = Mime::Type.lookup_by_extension(@file[:extension].gsub('.','')).to_s
      send_data(Base64.decode64(@file[:content]), type: content_type, filename: @file[:basename], disposition: 'attachment')
    end
  end
end

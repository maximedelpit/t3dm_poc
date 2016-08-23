class TopicsController < ApplicationController
  before_action :find_project, only: [:show, :create, :edit, :update, :destroy]
  def create
    @topic = @project.topics.build(topic_params)
    @topic.type ||= 'PullRequest'
    @topic.state = 'open'
    @topic.user = current_user
    @topic.project_state = @project.state_machine.current_state.to_sym
  end

  def show
    @topic = Topic.includes(:comments).find(params[:id])
    @comments = @topic.comments
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def topic_params
    params.require(:topic).permit(:type, :title, :body)
  end

end

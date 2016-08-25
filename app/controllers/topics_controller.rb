class TopicsController < ApplicationController
  before_action :find_project, only: [:show, :create, :edit, :update, :destroy]
  def create
    @topic = @project.topics.build(topic_params)
    @topic.type ||= 'PullRequest'
    @topic.state = 'open'
    @topic.user = current_user
    @topic.project_state = @project.state_machine.current_state.to_sym
    title = params[:topic][:title]
    content = params[:topic][:content]
    if @topic.type == 'PullRequest'

    else
      @gh_topic = TopicManager.new(current_user.id, @project.id).create_issue(title, content)
    end
    @topic.github_number = @gh_topic[:number]
    @topic.save
    @gh_topic[:topic] = @topic
  end

  def show
    @state_machine = @project.state_machine
    @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture("master")
    @topic = Topic.includes(:comments).find(params[:id]) # not sure to need include
    @topic_comments = TopicManager.new(current_user.id, @project.id).get_topic_and_comments(@topic.github_number)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def topic_params
    params.require(:topic).permit(:type, :title, :content)
  end

end

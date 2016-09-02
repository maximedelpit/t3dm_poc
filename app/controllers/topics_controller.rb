class TopicsController < ApplicationController
  before_action :find_project, only: [:show, :create, :edit, :update, :destroy]
  before_action :topic_update_params, only: :update

  def show
    @state_machine = @project.state_machine
    @repo_tree = RepoManager.new(current_user.id, @project.id).retrieve_repo_architecture("master")
    @topic = Topic.includes(:comments).find(params[:id]) # not sure to need include
    @topic_hash = TopicManager.new(current_user.id, @project.id).get_topic_hash(@topic.github_number)
    @comments = @topic.comments
    # @topic_comments = TopicManager.new(current_user.id, @project.id).get_topic_and_comments(@topic.github_number)
  end

  def create
    @topic = @project.topics.build(topic_params)
    @topic.type ||= 'PullRequest'
    @topic.state = 'open'
    @topic.user = current_user
    @topic.project_state = @project.state_machine.current_state.to_sym
    title = params[:topic][:title]
    content = params[:topic][:content]
    if @topic.type == 'PullRequest'
      #  TO DO ?
    else
      @gh_topic = TopicManager.new(current_user.id, @project.id).create_issue(title, content)
    end
    @topic.github_number = @gh_topic[:number]
    @topic.save
    @gh_topic[:topic] = @topic
  end

  def update
    @topic = Topic.find(params[:id])
    if params[:topic_action] == 'merged'
      github_response = TopicManager.new(current_user.id, @project.id).merge_topic_pr(@topic.github_number)
    elsif params[:topic_action] == 'closed' && @topic.state != 'closed'
      github_response = TopicManager.new(current_user.id, @project.id).close_issue(@topic.github_number)
    elsif params[:topic_action] == 'open' && @topic.state != 'open'
      github_response = TopicManager.new(current_user.id, @project.id).reopen_issue(@topic.github_number)
    end
    edit_state(github_response)
    @topic.save
    redirect_to project_topic_path(@project, @topic)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def topic_params
    params.require(:topic).permit(:type, :title, :content)
  end

  def topic_update_params
    params.permit(:topic_action)
  end

  def edit_state(github_response)
    if github_response[:merged] && @topic.type == 'PullRequest'
      @topic.state = 'closed'
    elsif github_response[:state] != @topic.state && @topic.type == 'Issue'
      @topic.state = github_response[:state]
    elsif github_response[:merged].nil? && @topic.type == 'PullRequest'
      @topic.errors << 'Something went wrong. Contact support.'
    end
  end
end

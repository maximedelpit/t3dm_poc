class TopicManager

  def initialize(user_id, project_id, options= {})
    @user = User.find(user_id)
    @octokit_client = Octokit::Client.new(:access_token => @user.token)
    @project = Project.find(project_id)
  end

  def create_issue(title, body=nil, options = {})
    issue = @octokit_client.create_issue(@project.repo_uri, title, body, options)
  end

  def get_project_topics(topics, filters={})
    # cache?
    filters[:sort] ||= "comments"
    gh_topics = @octokit_client.list_issues(@project.repo_uri, filters)
    relevant_numbers = topics.map(&:github_number)
    relevant_issues = gh_topics.select do |issue|
      relevant_numbers.include?(issue[:number]) &&
      issue[:topic] = topics.select {|t| t.github_number == issue[:number]}.first
    end
    return relevant_issues
  end

  def get_topic_and_comments(topic_number)
    topic_comments = {}
    topic_comments[:topic] = @octokit_client.issue(@project.repo_uri, topic_number)
    topic_comments[:comments] = @octokit_client.issue_comments(@project.repo_uri, topic_number)
    return topic_comments
  end
end

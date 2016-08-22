class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  # Handle push event
  def github_push(payload)
    # TODO: handle push webhook
    # TO DO create notif for users => Action Cable
    # TO DO invalidate / change cache
    # TO DO Action Cable for updateing repo_trees...
    repo_name = payload["repository"]["name"]
    @project = Project.find_from_repo_name(repo_name)
    @event = "Work submitted on #{@project.title}"
  end

  # Handle create event
  def github_create(payload)
    # TODO: handle create webhook
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end
end

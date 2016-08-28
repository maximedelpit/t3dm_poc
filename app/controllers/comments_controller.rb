class CommentsController < ApplicationController
  before_action :find_topic, only: [:create]
  before_action :find_comment, only: [:update, :destroy, :download]
  require 'open-uri'
  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user
    mentionned_users = check_mentions(@comment.content) if @comment.content
    mentionned_users.each {|u| @comment.mentions.build(user: u)}
    binding.pry
    @comment.save
    if @comment.attachment.format.nil?
      @comment.attachment.format = @comment.attachment.public_id.split('.').last
      @comment.attachment.save
    end
  end

  def update

  end

  def download
    attachment = @comment.attachment
    data = open(ENV['CLOUDINARY_BASE_URL'] + ENV['CLOUDINARY_URL'] + attachment.path)
    attachment.format ? content_type = 'image/png' : content_type = attachment.content_type
    send_data data.read, type: attachment.format, filename: attachment.filename
  end

  private

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def find_comment
    @topic = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :attachment, :pinned)
  end

  def check_mentions(content)
    mentions = content.scan(/@(\S+\b)/).flatten
    return User.where(github_login: mentions)
  end
end

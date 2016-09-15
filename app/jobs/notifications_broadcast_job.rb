class NotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(options={})
      # ActionCable.server.broadcast 'activity_channel', message: render_event(event)
      current_user = User.find(options[:user_id])
      resource = options[:resource_class].constantize.find(options[:resource_id])
      activities = {}
      options[:recipient_ids].each do | recipient_id |
        recipient = User.find(recipient_id)
        notification = resource.create_activity options[:action], owner: current_user, recipient: recipient
        # NotificationsChannel.broadcast_to(recipient, message: render_notification(notification))
        ActionCable.server.broadcast('notifications', message: 'coucou')

      end
    end

    private

    def render_notification(notification)
      ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
    end
end

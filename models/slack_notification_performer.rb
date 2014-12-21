require 'hashie'
require 'json'
require_relative 'slack_notification_sender'

include Java

java_import org.jenkinsci.plugins.tokenmacro.TokenMacro

class SlackNotificationPerformer

  def initialize(task,build,listener)
    @task = task
    @build = build
    @listener = listener
  end

  def perform
    sender = SlackNotificationSender.new @build, @listener, params
    return unless sender.should_send_notification?

    @listener.info "Sending Slack Notification"
    begin
      sender.send_notification
      @listener.info "Slack Notification Sent"
    rescue => e
      @listener.error ['An error occurred while sending the Slack Notification', e.message, e.backtrace] * "\n"
    end
  end

  private

    [ :access_token, :team_domain, :team_channel, :send_start_notification, :start_message, :send_success_notification, :success_message, :send_failure_notifications, :failure_message ].each do |field|
      define_method field do
        expand_field field
      end
    end

    def expand_field(field)
      # puts "Using TokenMacro to expand '#{field}'..."
      value = @task.instance_variable_get "@#{field}"
      # puts "  Value: #{value}"
      expanded_value = TokenMacro.expandAll @build.native, @listener.native, value
      # puts "  Expanded value: #{expanded_value}"
      expanded_value
    end

    def workspace_path
      @build.workspace.to_s
    end

    def params
      p = Hashie::Mash.new
      p[:access_token] = access_token
      p[:team_domain] = team_domain
      p[:success] = { text: success_message, channel: team_channel }
      p[:failure] = { text: failure_message, channel: team_channel }
      p
    end

end

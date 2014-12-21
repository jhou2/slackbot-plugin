require 'rest_client'

class SlackNotificationSender

  attr_reader :team_host, :hook_path, :channel, :text

  def initialize(build, listener, params)
    @build = build
    @listener = listener
    @params = params
    @team_host = "https://#{params.team_domain}.slack.com"
    @hook_path = "/services/hooks/jenkins-ci?token=#{params.access_token}"
  end

  def should_send_notification?
    (success? && @params.success) || (!success? && @params.failure)
  end

  def send_notification
    if ( success? && @params.success )
      @channel = @params.success.channel
      @text = @params.success.text
    elsif (!success && @params.failure )
      @channel = @params.failure.channel
      @text = @params.failure.text
    end

    body = Hash.new()

    body['channel'] = @channel
    body['username'] = 'jenkinsbot'
    body['text'] = @text

    RestClient.post "#{@team_host}#{@hook_path}", body.to_json, :content_type => :json, :accept => :json

    @listener.info("Should've sent")
  end

  private

    def success?
      @build.native.getResult.to_s == 'SUCCESS'
    end

    def message_info
      @message_info || success? ? @params.success : @params.failure
    end

    def body
      message_info.message
    end
end

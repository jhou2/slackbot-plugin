
# A single build step in the entire build process
class SlackNotifier < Jenkins::Tasks::Publisher

    display_name "Notify Slack Channel"

    attr_reader :access_token, :team_domain, :team_channel,
      :send_start_notification, :start_message,
      :send_success_notification, :success_message,
      :send_failure_notifications, :failure_message

    # Invoked with the form parameters when this extension point
    # is created from a configuration screen.
    def initialize(attrs = {})
      attrs.each { |k, v| instance_variable_set "@#{k}", v }
    end

    ##
    # Runs the step over the given build and reports the progress to the listener.
    #
    # @param [Jenkins::Model::Build] build on which to run this step
    # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build
    # @param [Jenkins::Model::Listener] listener the listener for this build.
    def perform(build, launcher, listener)
      get_global_config
      performer = SlackNotificationPerformer.new self, build, listener
      performer.perform
    end

    private

      def get_global_config
        global_config = Java.jenkins.model.Jenkins.getInstance().getDescriptor(SlackGlobalConfigDescriptor.java_class)
        instance_variable_set "@access_token", global_config.slack_token
        instance_variable_set "@team_domain", global_config.slack_team
        global_config
      end

end

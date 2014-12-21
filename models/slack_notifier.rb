# A single build step in the entire build process
class SlackNotifier < Jenkins::Tasks::Publisher

    display_name "Notify Slack Channel"

    attr_reader :access_token, :team_domain,
      :send_success_notification, :success_message, :success_group_name,
      :send_failure_notifications, :failure_message, :failure_group_name,
      :config_file

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
      # actually perform the build step
    end

end

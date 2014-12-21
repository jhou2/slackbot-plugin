require_relative 'slack_global_config_descriptor'

include Java

class SlackGlobalConfig < Jenkins::Model::RootAction
  include Jenkins::Model
  include Jenkins::Model::DescribableNative
  describe_as Java.hudson.model.Descriptor, :with => SlackGlobalConfigDescriptor
end

Jenkins::Plugin.instance.register_extension(SlackGlobalConfig)

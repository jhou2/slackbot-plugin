Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "slackbot"
  plugin.display_name = "Slackbot Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'TODO: enter description here'

  # You should create a wiki-page for your plugin when you publish it, see
  # https://wiki.jenkins-ci.org/display/JENKINS/Hosting+Plugins#HostingPlugins-AddingaWikipage
  # This line makes sure it's listed in your POM.
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Slackbot+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "randomfrequency", "Vincent Janelle <randomfrequency@gmail.com>"

  # This specifies where your code is hosted.
  # Alternatives include:
  #  :github => 'myuser/slackbot-plugin' (without myuser it defaults to jenkinsci)
  #  :git => 'git://repo.or.cz/slackbot-plugin.git'
  #  :svn => 'https://svn.jenkins-ci.org/trunk/hudson/plugins/slackbot-plugin'
  plugin.uses_repository :github => "slackbot-plugin"

  # This is a required dependency for every ruby plugin.
  plugin.depends_on 'ruby-runtime', '0.12'

  # This is a sample dependency for a Jenkins plugin, 'git'.
  #plugin.depends_on 'git', '1.1.11'
  plugin.depends_on 'token-macro', '1.10'
end

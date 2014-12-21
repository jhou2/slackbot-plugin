include Java

java_import Java.hudson.BulkChange
java_import Java.hudson.model.listeners.SaveableListener

java_import Java.java.util.logging.Logger
java_import Java.java.util.logging.Level

class SlackGlobalConfigDescriptor < Jenkins::Model::DefaultDescriptor
  def logger
    @logger ||= Logger.getLogger(MysqlGlobalConfigDescriptor.class.name)
  end

  attr_accessor :slack_token
  attr_accessor :slack_team

  def initialize(*)
    super
    load
  end

  # @see hudson.model.Descriptor#load()
  def load
    return unless configFile.file.exists()
    from_xml(File.read(configFile.file.canonicalPath))
  end

  # @see hudson.model.Descriptor#save()
  def save
    return if BulkChange.contains(self)

    begin
      File.open(configFile.file.canonicalPath, 'wb') { |f| f.write(to_xml) }
      SaveableListener.fireOnChange(self, configFile)
    rescue => e
      logger.log(Level::SEVERE, "Failed to save #{configFile}: #{e.message}")
    end
  end

  def configure(req, form)
    parse(form)

    save
    true
  end

  private

    def from_xml(xml)
      @slack_token = xml.scan(/<slack_token>(.*)<\/slack_token>/).flatten.first
      @slack_team = xml.scan(/<slack_team>(.*)<\/slack_team>/).flatten.first
    end


    def to_xml
      str = ""
      str << "<?xml version='1.0' encoding='UTF-8'?>\n"
      str << "<#{id} plugin=\"mysql-job-databases\">\n"
      str << "  <slack_token>#{slack_token}</slack_token>\n"
      str << "  <slack_team>#{slack_team}</slack_team>\n"
      str << "</#{id}>\n"
      str
    end


    def parse(form)
      @slack_token        = form["slack_token"]
      @slack_team    = form["slack_team"]
    end

end

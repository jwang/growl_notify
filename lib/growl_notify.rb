require 'appscript'

class GrowlNotify
  
  class << self
    include Appscript
    APPLICATIONS_DIR = "/Applications"
    attr_accessor :application_name, :default_notifications, :notifications, :icon
    @application_name = "Ruby Growl"
    @default_notifications = []
    @notifications = []
    @icon = nil
    @growl_app = "GrowlHelperApp"

    def config(&block)
      block.call(self)
      register
    end

    def reset!
      [:application_name, :default_notifications, :notifications, :icon].each do |meth|
        send(:"#{meth}=", nil)
      end
    end

    def register
      current_path = Dir.pwd
      Dir.chdir(APPLICATIONS_DIR)
      if File.exist?("GrowlHelperApp.app")
        @growl_app = "GrowlHelperApp"
      elsif File.exist?("Growl.app")
        @growl_app = "Growl"
      end
      app(@growl_app).register(:all_notifications => @notifications, :as_application => @application_name, :default_notifications => @default_notifications)
      Dir.chdir(current_path)
    end

    def send_notification(options= {})
      defaults = {:title => 'no title', :application_name => @application_name, :description => 'no description', :sticky => false, :priority => 0, :with_name => notifications.first}
      local_icon = @icon
      local_icon = options.delete(:icon) if options.include?(:icon)
      if local_icon
        defaults.merge!(:image_from_location => local_icon)
      end

      app(@growl_app).notify(defaults.merge(options))
    end

    def very_low(options={})
      options.merge!(:priority => -2)
      send_notification(options)
    end

    def moderate(options={})
      options.merge!(:priority => -1)
      send_notification(options)
    end

    def normal(options={})
      options.merge!(:priority => 0)
      send_notification(options)
    end

    def high(options={})
      options.merge!(:priority => 1)
      send_notification(options)
    end

    def emergency(options={})
      options.merge!(:priority => 2)
      send_notification(options)
    end

    def sticky!(options={})
      options.merge!(:sticky => true)
      send_notification(options)
    end
  end

end

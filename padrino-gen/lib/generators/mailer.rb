require 'thor'

module Padrino
  module Generators

    class Mailer < Thor::Group
      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "padrino-gen mailer [name]"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators::Actions
      include Padrino::Generators::Components::Actions

      desc "Description:\n\n\tpadrino-gen mailer generates a new Padrino mailer"

      argument :name, :desc => "The name of your padrino mailer"
      class_option :root, :aliases => '-r', :default => nil, :type => :string

      # Copies over the base sinatra starting project
      def create_mailer
        if in_app_root?(options[:root])
          simple_name = name.to_s.gsub(/mailer/i, '')
          @mailer_basename = "#{simple_name.downcase.underscore}_mailer"
          @mailer_klass    = "#{simple_name.downcase.camelize}Mailer"
          template "templates/mailer_initializer.rb.tt", app_root_path("config/initializers/mailer.rb"), :skip => true
          template "templates/mailer.rb.tt", app_root_path("app/mailers", "#{@mailer_basename}.rb")
          empty_directory app_root_path('app/views/', @mailer_basename)
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)" and return unless in_app_root?
        end
      end
    end

  end
end

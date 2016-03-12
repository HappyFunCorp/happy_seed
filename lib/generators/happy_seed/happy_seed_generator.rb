ENV['DISABLE_SPRING'] = 'true'

module HappySeed
  module Generators
    class HappySeedGenerator < Rails::Generators::Base
      protected
        def already_installed
          installed = self.class.fingerprint
          puts "#{self.class.to_s} has already been run" if installed
          installed
        end

        def fingerprint
          raise "Fingerprint not implemented in #{self.to_s}"
        end

        def require_generator kls
          if !kls.fingerprint
            name = kls.to_s.gsub( /.*::/, "" ).gsub( /Generator/, "" ).underscore
            puts "Running dependancy happy_seed:#{name}"
            generate "happy_seed:#{name}"
          end
        end

        def add_omniauth( provider, scope = nil, client_api = nil, init = nil )
          scopeline = nil
          scopeline = ", scope: \"#{scope}\"" if scope
          inject_into_file 'config/initializers/devise.rb', after: "==> OmniAuth\n" do <<-"RUBY"
    config.omniauth :#{provider}, ENV['#{provider.upcase}_APP_ID'], ENV['#{provider.upcase}_APP_SECRET']#{scopeline}
  RUBY
          end
          begin
            add_env "#{provider.upcase}_APP_ID"
            add_env "#{provider.upcase}_APP_SECRET"
          rescue
            say_status :env, "Unable to add template variables to .env", :red
          end

          client_api ||= provider.to_s.humanize
          init ||= "access_token: #{provider}.accesstoken"
          inject_into_file 'app/controllers/omniauth_callbacks_controller.rb', "\n  def #{provider}\n    generic_callback( '#{provider}' )\n  end\n", before: /\s*def generic_callback/
          inject_into_file 'app/models/user.rb', :before => "\nend" do <<-"RUBY"

  def #{provider}
    identities.where( :provider => "#{provider}" ).first
  end

  def #{provider}_client
    @#{provider}_client ||= #{client_api}.client( #{init} )
  end
RUBY
          end
        end
     
        def gem_available?(name)
          self.gem_available?( name )
        end

        def self.gem_available?( name )
          Bundler.with_clean_env do
            begin
              return Bundler.environment.gem name
            rescue Gem::LoadError
              false
            end
          end
        end

        def add_env( key )
          defaults_file = File.expand_path ".seed_defaults", ENV['HOME']
          value = "#{key}=\n"
          if File.exists? defaults_file
            value = File.readlines( defaults_file ).grep( /#{key}=/ ).first || value
          end
          append_to_file ".env", value
        end
    end
  end
end
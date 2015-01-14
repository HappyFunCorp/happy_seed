module HappySeed
  module Generators
    class HappySeedGenerator < Rails::Generators::Base
      protected
        def require_omniauth
          unless gem_available?( "devise" )
            puts "The omniauth generator requires devise"

            if yes?( "Run happy_seed:devise now?" )
              generate "happy_seed:devise"
            else
              exit
            end
          end

          unless File.exists? 'app/models/identity.rb'
            generate "happy_seed:omniauth"
          end
        end

        def add_omniauth( provider, scope = nil )
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

          inject_into_file 'app/controllers/omniauth_callbacks_controller.rb', "\n  def #{provider}\n    generic_callback( '#{provider}' )\n  end\n", before: /\s*def generic_callback/
          inject_into_file 'app/models/user.rb', :before => "\nend" do <<-"RUBY"

  def #{provider}
    identities.where( :provider => "#{provider}" ).first
  end

  def #{provider}_client
    @#{provider}_client ||= #{provider.to_s.humanize}.client( access_token: #{provider}.accesstoken )
  end
RUBY
          end
        end
     
        def gem_available?(name)
          Gem::Specification.find_by_name(name)
        rescue Gem::LoadError
          false
        rescue
          Gem.available?(name)
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
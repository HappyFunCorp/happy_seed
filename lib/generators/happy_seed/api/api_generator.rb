module HappySeed
  module Generators
    class ApiGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_device_invitable
        unless gem_available?( "devise" )
          puts "The api generator requires devise"

          if yes?( "Run happy_seed:devise now?" )
            generate "happy_seed:devise"
          else
            exit
          end
        end

        gem 'apitome'
        gem 'rspec_api_documentation', :groups => [:development, :test]
        gem 'faker', :groups => [:development, :test]

        Bundler.with_clean_env do
          run "bundle install > /dev/null"
        end

        generate "model user_token user:belongs_to:index token installation_identifier:index push_token locked:boolean"

        directory '.'

        route "  scope module: :api, defaults: {format: :json} do
    %w(v1).each do |version|
      namespace version.to_sym do
        resource :user_token, path: :token, only: %w(create destroy update)
        resources :users, only: %w(create update show) do
          resources :questions, only: %w(index)
          collection do
            post :invite
            post :forgot_password
            put :reset_password
          end
        end
      end
    end
  end
"
        inject_into_class "app/models/user.rb", "User", "  has_many :user_tokens\n"

        gsub_file "app/models/user_token.rb", /belongs_to :user\n/,"  validates :user, presence: true
  validates :token, presence: true, uniqueness: {case_sensitive: false}
  validates :installation_identifier, presence: true, uniqueness: {case_sensitive: false, scope: %w(user_id)}
  validates :push_token, allow_blank: true, uniqueness: {case_sensitive: false}

  scope :with_push_token, -> { where.not push_token: nil }

  belongs_to :user, counter_cache: true

  before_validation :set_token

  private

  def set_token
    self.token ||= loop do
      token = Devise.friendly_token.downcase
      break token unless self.class.where(token: token).first.present?
    end
  end
"

        append_to_file 'spec/spec_helper.rb', "\nRspecApiDocumentation.configure do |config|
  config.format = :json
  config.docs_dir = Rails.root.join 'docs', 'api'

  config.request_headers_to_include = %w(Authorization)
  config.response_headers_to_include = %w()
end"

      end

      private
        def gem_available?(name)
          Gem::Specification.find_by_name(name)
        rescue Gem::LoadError
          false
        rescue
          Gem.available?(name)
        end

    end
  end
end
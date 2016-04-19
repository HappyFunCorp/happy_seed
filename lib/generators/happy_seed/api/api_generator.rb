require 'generators/happy_seed/devise/devise_generator'

module HappySeed
  module Generators
    class ApiGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'apitome'
      end

      def install_api
        return if already_installed

        gem 'apitome'
        gem_group :development, :test do
          gem 'rspec-rails'
          gem 'factory_girl_rails'
          gem 'faker'
          gem 'rspec_api_documentation'
        end

        generate 'rspec:install'

        require_generator DeviseGenerator

        Bundler.with_clean_env do
          run 'bundle install --without production'
        end

        generate 'model UserToken user:belongs_to token:string installation_identifier:string locked:boolean form_factor:string os:string'
        generate 'migration AddUserTokensCountToUsers push_token:string user_tokens_count:integer'

        directory '.'

        route "scope module: :api, defaults: {format: :json} do
    %w(v1).each do |version|
      namespace version.to_sym do
        resources :users, only: %w(create update show) do
          collection do
            post :forgot_password
            put :reset_password
          end
        end
        resource :user_token, path: :token, only: %w(create destroy)
      end
    end
  end\n"

        inject_into_class 'app/models/user.rb', 'User' do
          "  has_many :user_tokens, dependent: :destroy
  validates :push_token, allow_blank: true, uniqueness: {case_sensitive: false}"
        end

        gsub_file "app/models/user_token.rb", /belongs_to :user\n/, "  validates :user, presence: true
  validates :token, presence: true, uniqueness: {case_sensitive: false}
  validates :installation_identifier, presence: true, uniqueness: {case_sensitive: false, scope: %w(user_id)}
  validates :form_factor, allow_blank: true, inclusion: {in: %w(smartphone tablet10 tablet7 desktop)}
  validates :os, allow_blank: true, inclusion: {in: %w(ios android bb wp7)}

  belongs_to :user, counter_cache: true

  before_validation :set_token

  private

  def set_token
    self.token ||= loop do
      token = Devise.friendly_token.downcase
      break token unless self.class.where(token: token).first.present?
    end
  end\n"

        append_to_file 'spec/rails_helper.rb', "\nRspecApiDocumentation.configure do |config|
  config.format = :json
  config.docs_dir = Pathname('docs/api')

  config.request_headers_to_include = %w(Authorization)
  config.response_headers_to_include = %w()
end"

        insert_into_file 'spec/factories/users.rb', after: /factory :user do\s*$/ do
          "\n    push_token { Faker::Lorem.characters 10 }\n"
        end

        insert_into_file 'spec/factories/users.rb', before: /end\s*\z/ do
          "\n  factory :user_with_token, parent: :user do
    after :build do |user, evaluator|
      user.user_tokens.build installation_identifier: Faker::Lorem.characters(10),
      form_factor: %w(smartphone tablet10 tablet7 desktop).sample,
      os: %w(ios android bb wp7).sample
    end
  end\n"
        end

        rake 'db:migrate:reset', env: 'test'
        rake 'docs:generate', env: 'test'
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
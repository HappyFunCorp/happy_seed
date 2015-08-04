require 'generators/happy_seed/devise/devise_generator'

module HappySeed
  module Generators
    class ApiGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'apitome'
      end

      def install_device_invitable
        return if already_installed

        require_generator DeviseGenerator

        gem 'apitome'
        gem 'rspec_api_documentation', :groups => [:development, :test]

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        generate "model user_token user:belongs_to:index token installation_identifier:index push_token locked:boolean form_factor os"
        generate "migration add_user_tokens_count_to_users user_tokens_count:integer"

        directory '.'

        route "  scope module: :api, defaults: {format: :json} do
    %w(v1).each do |version|
      namespace version.to_sym do
        resource :configuration, only: %w(show)
        resource :user_token, path: :token, only: %w(create destroy update)
        resources :users, only: %w(create update show) do
          resources :questions, only: %w(index)
          collection do
            post :forgot_password
            put :reset_password
          end
        end
      end
    end
  end
"
        inject_into_class "app/models/user.rb", "User", "  has_many :user_tokens, dependent: :destroy\n"

        gsub_file "app/models/user_token.rb", /belongs_to :user\n/, "  validates :user, presence: true
  validates :token, presence: true, uniqueness: {case_sensitive: false}
  validates :installation_identifier, presence: true, uniqueness: {case_sensitive: false, scope: %w(user_id)}
  validates :push_token, allow_blank: true, uniqueness: {case_sensitive: false}
  validates :form_factor, allow_blank: true, inclusion: {in: %w(smartphone tablet10 tablet7 desktop)}
  validates :os, allow_blank: true, inclusion: {in: %w(ios android bb wp7)}

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

        prepend_to_file 'spec/spec_helper.rb', "require 'rspec_api_documentation'\n"
        append_to_file 'spec/spec_helper.rb', "\nRspecApiDocumentation.configure do |config|
  config.format = :json
  config.docs_dir = Pathname( 'docs/api' )

  config.request_headers_to_include = %w(Authorization)
  config.response_headers_to_include = %w()
end"

        append_to_file 'spec/factories/users.rb', "\nFactoryGirl.define do
  factory :user_with_token, parent: :user do
    after :build do |user, evaluator|
      user.user_tokens.build installation_identifier: Faker::Lorem.characters(10), push_token: Faker::Lorem.characters(10),
                             form_factor: %w(smartphone tablet10 tablet7 desktop).sample, os: %w(ios android bb wp7).sample
    end
  end
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
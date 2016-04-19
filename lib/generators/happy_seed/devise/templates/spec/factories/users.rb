# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| Faker::Internet.safe_email 'User %d' % n }
end

FactoryGirl.define do
  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    if User.devise_modules.include?(:confirmable)
      confirmed_at Time.now
    end
  end
end
FactoryGirl.define do
  factory :oauth_user, :class => 'User' do
    before(:create) do |user, evaluator|
      user.oauth_callback = true
    end
    if User.devise_modules.include? :confirmable
      confirmed_at Time.now
    end
  end
end
FactoryGirl.define do
  factory :oauth_user, :class => 'User' do
    before(:create) do |user, evaluator|
      user.oauth_callback = true
    end
  end
end
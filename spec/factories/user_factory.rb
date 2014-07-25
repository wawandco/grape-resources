FactoryGirl.define do
  factory :user do |user|
    sequence(:name) { |n| "name_#{n}" }
    sequence(:email) { |n| "email_#{n}@test.com" }
  end
end
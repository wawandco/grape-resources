FactoryGirl.define do
  factory :car do |user|
    sequence(:name) { |n| "name_#{n}" }
    sequence(:model) { |n| "#{n}" }
    sequence(:weight) { |n| n*100 }
  end
end
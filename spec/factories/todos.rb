FactoryBot.define do
  factory :todo do
    sequence(:title) { |n| "Todo #{n}" }
    description { "This is a sample todo description." }
    status { :pending }
    sequence(:position) { |n| n }

    trait :completed do
      status { :completed }
    end

    trait :pending do
      status { :pending }
    end
  end
end

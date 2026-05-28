FactoryBot.define do
  factory :todo do
    association :user

    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    completed { false }
    deleted_at { nil }

    trait :completed do
      completed { true }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end

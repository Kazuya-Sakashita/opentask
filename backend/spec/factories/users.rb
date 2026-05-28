FactoryBot.define do
  factory :user do
    supabase_user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end

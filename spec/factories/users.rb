FactoryBot.define do 
	factory :user do
		sequence(:name) { |n| "username_#{n}" }
    sequence(:balance) { |n| n * 100 }
	end
end
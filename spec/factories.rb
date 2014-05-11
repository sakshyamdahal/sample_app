FactoryGirl.define do
	factory :user do
		# name "Sam"
		# email "sdahal@claflin.edu"
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_n#{n}@example.com" }
		password "secret"
		password_confirmation "secret"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "hello world"
		user
	end
end

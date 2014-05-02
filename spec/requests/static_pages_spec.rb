require 'spec_helper'

describe "Static pages" do

	let(:base_title) {"Ruby on Rails Tutorial Sample App"}

	describe "Home page" do # can be anything except "home page"

		it "should have the content 'SAMPLE APP'" do
			visit root_path
			expect(page).to have_content('Sample App')
		end

		it "should have the title 'Home'" do
			visit root_path
			expect(page).to have_title("#{base_title}")
		end

		it "should not have custom page title" do
			visit root_path
			expect(page).not_to have_title('| Home')
		end
	end

	describe "Help page" do
		it "should have content 'Help'" do
			visit help_path
			expect(page).to have_content("Help")
		end

		it "should have the title 'Help'" do
			visit help_path
			expect(page).to have_title("#{base_title} | Help")
		end
	end

	describe "About page" do

		it "should have content 'About Us'" do
			visit about_path
			expect(page).to have_content("About Us")
		end

		it "should have the title 'About Us'" do
			visit about_path
			expect(page).to have_title("#{base_title} | About Us")
		end
	end

	describe "Contact page" do
		it "should have content 'Contact Us'" do
			visit contact_path
			expect(page).to have_content("Contact")
		end

		it "should have the title 'Contact Us'" do
			visit contact_path
			expect(page).to have_title("#{base_title} | Contact Us")
		end
	end
end

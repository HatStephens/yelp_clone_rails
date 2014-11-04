require 'rails_helper'

describe 'restaurants' do
	context 'no restaurants have been added' do
		it 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content "No restaurants"
			expect(page).to have_link "Add a restaurant"
		end
	end

	context 'restaurants have been added' do
		before do
			Restaurant.create(name: "KFC")
		end

		it 'should display restaurants' do
			visit '/restaurants'
			expect(page).to have_content('KFC')
			expect(page).not_to have_content('No restaurants')
		end
	end

	context 'viewing restaurants' do
		before do
			@kfc = Restaurant.create(name:'KFC', description: "Bucket food.")
		end

		it "lets a user view restaurant" do
			visit '/restaurants'
			click_link 'KFC'
			expect(page).to have_content "KFC"
			expect(page).to have_content "Bucket food."
			expect(current_path).to eq "/restaurants/#{@kfc.id}"
		end
	end

	context 'editing restaurants' do
		before do
			Restaurant.create(name:'KFC')
			User.create(email:'test@test.com', password:'testtest')
		end

	it 'lets a user edit the restaurant in they are signed in' do
		visit('/')
		click_link 'Sign in'
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Password', with: 'testtest'
		click_button 'Log in'
		click_link 'Edit KFC'
		fill_in 'Name', with: 'Kentucky Fried Chicken'
		fill_in 'Description', with: 'Bucket food.'
		click_button 'Update Restaurant'
		expect(page).to have_content 'Kentucky Fried Chicken'
		expect(current_path).to eq '/restaurants'
		end

	it 'does not allow a user to edit a restaurant if they are not signed in' do
		visit('/')
		click_link 'Edit KFC'
		expect(current_path).to eq '/users/sign_in'
		expect(page).not_to have_content 'KFC'
	end

	end

end

describe 'creating restaurants' do
	before do
		User.create(email: 'test@test.com', password: 'testtest')
		visit('/')
		click_link 'Sign in'
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Password', with: 'testtest'
		click_button 'Log in'
	end

	it 'prompts user to fill out a form, then displays a new restaurant' do
		visit '/restaurants'
		click_link 'Add a restaurant'
		fill_in 'Name', with: 'KFC'
		fill_in 'Description', with: 'Bucket food.'
		click_button 'Create Restaurant'
		expect(page).to have_content 'KFC'
		expect(current_path).to eq '/restaurants'
	end

describe 'deleting restaurants' do

	before do
		Restaurant.create(name: "KFC")
	end

		it "Remove a restaurant when a user clicks a delete link" do
			visit "/restaurants"
			click_link 'Delete KFC'
			expect(page).not_to have_content "KFC"
			expect(page).to have_content "Restaurant deleted successfully"
		end
	end
end

describe 'creating restaurants when signed in' do

	before do
		User.create(email: 'test@test.com', password: 'testtest')
		visit('/')
		click_link 'Sign in'
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Password', with: 'testtest'
		click_button 'Log in'
	end

	context 'an invalid restaurant' do
		it 'does not let you submit a name that is blank' do
			visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: ''
      click_button 'Create Restaurant'
      expect(page).to have_content 'error'
    end

    it "is not valid unless it has a unique name" do
  		Restaurant.create(name: "Moe's Tavern")
  		restaurant = Restaurant.new(name: "Moe's Tavern")
  		expect(restaurant).to have(1).error_on(:name)
		end

  end
end






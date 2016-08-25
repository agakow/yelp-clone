require 'rails_helper'

feature 'reviewing' do

  context 'creating a review' do

    before do
      sign_up
      create_restaurant
    end

    scenario 'allows users to leave a review using a form' do
      create_review("so so", "3")
      click_link 'KFC'
      expect(page).to have_content 'so so'
    end
  end

  context 'editing reviews' do

    before do
      sign_up
      create_restaurant
      create_review("so so", "3")
    end

    scenario 'let a user edit a review' do
      click_link 'KFC'
      click_link 'Edit Review'
      fill_in 'Thoughts', with: 'very bad'
      select '1', from: 'Rating'
      click_button 'Update Review'
      expect(page).to have_content 'very bad'
      expect(page).to have_content 'Rating: 1'
    end
  end

  context 'deleting reviews' do

    before do
      sign_up
      create_restaurant
      create_review("so so", "3")
    end

    scenario 'lets a user delete a review they created' do
      visit '/restaurants'
      click_link 'KFC'
      click_link 'Delete Review'
      id = Restaurant.first.id
      expect(page).to have_content 'Review deleted successfully'
      expect(current_path).to eq "/restaurants/#{id}"
    end

    scenario 'will not let a user delete a review they did not create' do
      click_link 'Sign out'
      sign_up(email: 'test@example.com')
      click_link 'KFC'
      expect(page).not_to have_link 'Delete Review'
    end
  end

end

require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add restaurant'
     end
  end

  context 'restuarants have been added' do
    before { Restaurant.new(name: 'KFC', description: 'Deep fried goodness').save(validate: false) }
    scenario 'should display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    context 'Not signed in' do
      scenario 'does not allow user to create restaurant unless signed in' do
        visit '/restaurants'
        click_link 'Add restaurant'
        expect(page).to have_content 'You need to sign in or sign up before continuing'
        expect(page).not_to have_link 'Create Restaurant'
      end
    end

    context 'Signed in' do

      before do
        sign_up
      end

      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        click_link 'Add restaurant'
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: 'Deep fried goodness'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      context 'an invalid restaurant' do
        it 'does not allow to submit a name that is too short' do
          click_link 'Add restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end
  end


  context 'viewing restaurants' do
    scenario 'lets a user view a restaurant' do
      sign_up
      create_restaurant
      id = Restaurant.first.id
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{id}"
    end
  end

  context 'editing restaurants' do

    before do
      sign_up
      create_restaurant
    end

    scenario 'let a user edit a restaurant' do
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep Fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'will not let a user edit a restaurant they did not create' do
      click_link 'Sign out'
      sign_up(email: 'test@example.com')
      expect(page).not_to have_link 'Edit KFC'
    end

    scenario 'will not let a user edit a restaurant if not signed in' do
      click_link 'Sign out'
      expect(page).not_to have_link 'Edit KFC'
    end

  end

  context 'deleting restaurants' do

    before do
      sign_up
      create_restaurant
    end

    scenario 'lets a user delete a restaurant' do
      click_link 'Delete KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
      expect(page).not_to have_content 'KFC'
    end

    scenario 'will not let a user delete a restaurant they did not create' do
      click_link 'Sign out'
      sign_up(email: 'test@example.com')
      expect(page).not_to have_link 'Delete KFC'
    end

    scenario 'will not let a user delete a restaurant if not signed in' do
      click_link 'Sign out'
      expect(page).not_to have_link 'Delete KFC'
    end
  end


end

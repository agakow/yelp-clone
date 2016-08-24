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
    before do
      Restaurant.create(name: 'KFC', description: 'Deep fried goodness')
    end


    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'Not signed in' do
    scenario 'does not allow user to create restaurant unless signed' do
      visit '/restaurants'
      click_link 'Add restaurant'
      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).not_to have_link 'Create Restaurant'
    end
  end

  context 'creating restaurants' do

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

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name: 'KFC', description: 'Deep fried goodness')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'User signed in' do

    before do
      sign_up
    end

    context 'editing restaurants' do

      before { Restaurant.create(name: 'KFC', description: 'Deep fried goodness')}

      scenario 'let a user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        fill_in 'Description', with: 'Deep Fried goodness'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do

      before {Restaurant.create name: 'KFC', description: 'Deep fried goodness'}

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end
  end

end

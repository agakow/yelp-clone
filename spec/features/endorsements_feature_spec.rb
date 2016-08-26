require 'rails_helper'

feature 'endorsing reviews' do
  before do
    sign_up
    create_restaurant
    create_review("meh", "2")
  end

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    click_link 'KFC'
    click_link 'Endorse Review'
    click_link 'KFC'
    expect(page).to have_content('1 endorsement')
  end

end

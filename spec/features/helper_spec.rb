
def sign_up(email: 'alice@example.com')
  visit new_user_registration_path
  fill_in 'Email', with: email
  fill_in 'Password', with: '12345678'
  fill_in 'Password confirmation', with: '12345678'
  click_button 'Sign up'
end

def create_restaurant
  visit '/restaurants'
  click_link 'Add restaurant'
  fill_in 'Name', with: 'KFC'
  fill_in 'Description', with: 'Deep Fried goodness'
  click_button 'Create Restaurant'
end

def create_review
  click_link 'Review KFC'
  fill_in 'Thoughts', with: "so so"
  select '3', from: 'Rating'
  click_button 'Leave Review'
end

class NewUserForm
    include Capybara::DSL

    def user_sign_in
        StaticPage.create!(title: 'getting started', body: 'remote pair programming')
        email = "go@go.com"
        password = "12345678"
        @current_user = @user = FactoryBot.create(:signed_in_user, 
        email: email, password: password, password_confirmation: password)


        visit('/users/sign_in')
        within('#main') do
            fill_in 'user_email', with: email
            fill_in 'user_password', with: password
            click_button 'Sign in'
        end
        self
    end

    def admin_user_sign_in
        StaticPage.create!(title: 'getting started', body: 'remote pair programming')
        email = "go@go.com"
        password = "12345678"
        @current_user = @user = FactoryBot.create(:signed_in_user, 
        email: email, password: password, password_confirmation: password, admin: true)


        visit('/users/sign_in')
        within('#main') do
            fill_in 'user_email', with: email
            fill_in 'user_password', with: password
            click_button 'Sign in'
        end
        self
    end
 
 end
# require_relative '../support/new_user_form'

feature 'user cannot access new project page if signed out' do
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user, admin: false) }

  scenario "is expected to set newly created project status to 'Pending'" do
    login_as user, scope: :user
    visit('/projects/new')
    fill_in('Title', with: 'Read a book')
    fill_in('Description', with: 'Excellent read')

    click_button('Submit')
    expect(Project.last.status).to eq('Pending')
  end

  feature 'Non-admin user attempts to access pending projects page' do
    before do
      login_as user, scope: :user
      visit('/pending_projects')
    end

    it "is expected to have text 'You do not have permission to perform that operation' " do
      expect(page).to have_content('You do not have permission to perform that operation')
    end
  end

  feature 'Non-admin user cannot edit projects they did not create' do
    before do
      login_as user, scope: :user
      project = create(:project)
      visit("/projects/#{project.id}/edit")
    end

    it "is expected to have text 'You do not have permission to perform that operation' " do
      expect(page).to have_content('You do not have permission to perform that operation')
    end
  end

  feature 'Non-admin user cannot see activate button on project page' do
    before do
      login_as user, scope: :user
      project = create(:project, status: 'Pending')
      visit("/projects/#{project.id}")
    end

    it "is expected to not have text 'Activate Project' " do
      expect(page).to have_no_content('Activate Project')
    end
  end

  feature 'Non-admin user cannot see deactivate button on project page' do
    before do
      login_as user, scope: :user
      project = create(:project, status: 'Active')
      visit("/projects/#{project.id}")
    end
    
    it "is expected to not have text 'Deactivate Project' " do
      expect(page).to have_no_content('Deactivate Project')
    end
  end

  feature 'Admin user can access pending projects page' do
    before do
      login_as admin, scope: :user
      visit('/pending_projects')
    end
     
    it "is expected to have text 'List of Pending Projects' " do
      expect(page).to have_content('List of Pending Projects')
    end
  end

  feature 'Admin user can see activate button on project page' do
    before do
      login_as admin, scope: :user
      project = create(:project, status: 'Pending')
      visit("/projects/#{project.id}")
    end

    it "is expected to have text 'Activate Project'" do
      expect(page).to have_content('Activate Project')
    end
  end

  feature 'Admin user can see deactivate button on project page' do
    before do
      login_as admin, scope: :user
      @project = create(:project, status: 'Active')
      visit("/projects/#{@project.id}")
    end

    it "is expected to have text 'Deactivate Project' " do
      expect(page).to have_content('Deactivate Project')
    end
  end
end

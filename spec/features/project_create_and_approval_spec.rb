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

    it do
      expect(page).to have_content('You do not have permission to perform that operation')
    end
  end

  feature 'Non-admin user cannot edit projects they did not create' do
    before do
      login_as user, scope: :user
      project = create(:project)
      visit("/projects/#{project.id}/edit")
    end

    it do
      expect(page).to have_content('You do not have permission to perform that operation')
    end
  end

  feature 'Non-admin user cannot see activate button on project page' do
    before do
      login_as user, scope: :user
      visit('/projects/new')
    end

    it 'is expected to....' do
      expect(page).to have_content('Creating a new Project')

      fill_in('Title', with: 'Read a book')
      fill_in('Description', with: 'Excellent read')

      click_button('Submit')

      expect(Project.last.title).to eq('Read a book')
      expect(Project.last.status).to eq('Pending')

      visit("/projects/#{Project.last.id}")
      expect(page).to have_no_content('Activate Project')
    end
  end

  scenario 'Non-admin user cannot see deactivate button on project page' do
    # new_user_form.user_sign_in
    login_as user, scope: :user
    @project = create(:project, status: 'Active')

    visit("/projects/#{@project.id}")
    expect(page).to have_no_content('Deactivate Project')
  end

  scenario 'Admin user can access pending projects page' do
    # new_user_form.admin_user_sign_in
    login_as admin, scope: :user

    visit('/pending_projects')
    expect(page).to have_content('List of Pending Projects')
  end

  scenario 'Admin user can see activate button on project page' do
    # new_user_form.admin_user_sign_in
    login_as admin, scope: :user

    visit('/projects/new')
    expect(page).to have_content('Creating a new Project')

    fill_in('Title', with: 'Read a book')
    fill_in('Description', with: 'Excellent read')

    click_button('Submit')

    expect(Project.last.title).to eq('Read a book')
    expect(Project.last.status).to eq('Pending')

    visit("/projects/#{Project.last.id}")
    expect(page).to have_content('Activate Project')
  end

  scenario 'Admin user can see deactivate button on project page' do
    # new_user_form.admin_user_sign_in
    login_as admin, scope: :user

    @project = create(:project, status: 'Active')

    visit("/projects/#{@project.id}")
    expect(page).to have_content('Deactivate Project')
  end
end

# require_relative '../support/new_user_form'

describe 'Project is subject to approval' do
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user, admin: false) }

  subject { page }

  feature 'upon creation by a user without admin rights' do
    scenario "is expected to set newly created project status to 'Pending'" do
      login_as user, scope: :user
      visit('/projects/new')
      fill_in('Title', with: 'Read a book')
      fill_in('Description', with: 'Excellent read')

      click_button('Submit')
      expect(Project.last.status).to eq('pending')
    end
  end

  feature 'user without admin rights attempts to access pending projects page' do
    before do
      login_as user, scope: :user
      visit('/pending_projects')
    end

    it {
      is_expected
        .to have_content('You do not have permission to perform that operation')
    }
  end

  feature 'user without admin rights cannot access edit projects view for a project they did not create' do
    before do
      login_as user, scope: :user
      project = create(:project, user: admin)
      visit("/projects/#{project.id}/edit")
    end

    it {
      is_expected
        .to have_content('You do not have permission to perform that operation')
    }
  end

  # Add spec for Admin user being okay to access? 
  feature 'user with admin rights can access edit projects view for a project they did not create' do
    let!(:project) { create(:project, user: user) }
    
    before do
      login_as admin, scope: :user
      visit("/projects/#{project.id}/edit")
      save_and_open_page
    end

    it {
      is_expected.to have_current_path("/projects/#{project.id}/edit")
    }

    it {
      is_expected
        .to have_no_content('You do not have permission to perform that operation')
    }
  end

  feature 'user without admin rights cannot see activate button on project page' do
    before do
      login_as user, scope: :user
      project = create(:project, status: 'pending')
      visit("/projects/#{project.id}")
    end

    it {
      is_expected
        .to have_no_content('Activate Project')
    }
  end

  feature 'user without admin rights cannot see deactivate button on project page' do
    before do
      login_as user, scope: :user
      project = create(:project, status: 'active')
      visit("/projects/#{project.id}")
    end

    it {
      is_expected
        .to have_no_content('Deactivate Project')
    }    
  end

  feature 'user with admin rights can access pending projects page' do
    before do
      login_as admin, scope: :user
      visit('/pending_projects')
    end

    it {
      is_expected
        .to have_content('List of Pending Projects')
    }    

  end

  feature 'user with admin rights can see activate button on project page' do
    before do
      login_as admin, scope: :user
      project = create(:project, status: 'pending')
      visit("/projects/#{project.id}")
    end

    it {
      is_expected
        .to have_content('Activate Project')
    } 
  end

  feature 'user with admin rights can see deactivate button on project page' do
    before do
      login_as admin, scope: :user
      @project = create(:project, status: 'active')
      visit("/projects/#{@project.id}")
      save_and_open_page
    end

    it {
      is_expected
        .to have_content('Deactivate Project')
    } 
  end
end

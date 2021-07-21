require 'rails_helper'
require_relative '../support/new_user_form'

feature 'user cannot access new project page if signed out' do
    let(:new_user_form) {NewUserForm.new}


    scenario "newly created project status is 'Pending' by default " do
        new_user_form.user_sign_in

        visit('/projects/new')
        expect(page).to have_content('Creating a new Project')

        fill_in('Title', with: 'Read a book')
        fill_in('Description', with: 'Excellent read')
        
        click_button('Submit')

        expect(Project.last.title).to eq("Read a book")
        expect(Project.last.status).to eq("Pending")
        
    end

    scenario 'Non-admin user cannot access pending projects page' do
        new_user_form.user_sign_in
        
        visit('/pending_projects')
        expect(page).to have_content('You do not have permission to perform that operation')
    end

    
    
    scenario 'Non-admin user cannot edit projects they did not create' do
        new_user_form.user_sign_in
        @project = FactoryBot.create(:project)

        visit("/projects/#{@project.id}/edit")
        expect(page).to have_content('You do not have permission to perform that operation')
    end

    scenario 'Non-admin user cannot see activate button on project page' do
        new_user_form.user_sign_in

        visit('/projects/new')
        expect(page).to have_content('Creating a new Project')

        fill_in('Title', with: 'Read a book')
        fill_in('Description', with: 'Excellent read')
        
        click_button('Submit')

        expect(Project.last.title).to eq("Read a book")
        expect(Project.last.status).to eq("Pending")

        visit("/projects/#{Project.last.id}")
        expect(page).to have_no_content('Activate Project')
    end

    scenario 'Non-admin user cannot see deactivate button on project page' do
        new_user_form.user_sign_in
        @project = FactoryBot.create(:project, status: "Active")


        visit("/projects/#{@project.id}")
        expect(page).to have_no_content('Deactivate Project')
    end

    scenario 'Admin user can access pending projects page' do
        new_user_form.admin_user_sign_in
        
        visit('/pending_projects')
        expect(page).to have_content('List of Pending Projects')
    end


    scenario 'Admin user can see activate button on project page' do
        new_user_form.admin_user_sign_in

        visit('/projects/new')
        expect(page).to have_content('Creating a new Project')

        fill_in('Title', with: 'Read a book')
        fill_in('Description', with: 'Excellent read')
        
        click_button('Submit')

        expect(Project.last.title).to eq("Read a book")
        expect(Project.last.status).to eq("Pending")

        visit("/projects/#{Project.last.id}")
        expect(page).to have_content('Activate Project')
    end

    scenario 'Admin user can see deactivate button on project page' do
        new_user_form.admin_user_sign_in
        @project = FactoryBot.create(:project, status: "Active")


        visit("/projects/#{@project.id}")
        expect(page).to have_content('Deactivate Project')
    end
end
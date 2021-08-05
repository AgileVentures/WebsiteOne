# frozen_string_literal: true

Then(/^I should see "([^"]*)" table$/) do |legend|
  expect(page).to have_css 'h1', text: legend
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    if hash[:author].present?
      u = User.find_by_first_name hash[:author]
      project = Project.new(hash.except('author', 'tags').merge(user_id: u.id))
    else
      project = default_test_author.projects.new(hash.except('author', 'tags', 'languages'))
    end
    if hash[:github_url].present?
      hash[:github_url].split(', ').each do |source_repository|
        project.source_repositories.build(url: source_repository)
      end
    end
    if hash[:languages].present?
      language = Language.find_or_create_by(name: hash[:languages])
      project.languages << language
    end
    if hash[:pivotaltracker_url] && !hash[:pivotaltracker_url].empty?
      project.issue_trackers.build(url: hash[:pivotaltracker_url])
    end
    project.tag_list.add(hash[:tags], parse: true) if hash[:tags]
    project.save!
  end
end

Given(/^the following source repositories exist:$/) do |table|
  table.hashes.each do |hash|
    project = Project.find_by(title: hash[:project])
    project.source_repositories.delete_all
    source_repository = SourceRepository.new(url: hash[:url], project_id: project.id)
    source_repository.save!
  end
end

Given(/^the following legacy projects exist:$/) do |table|
  # table is a table.hashes.keys # => [:title, :description, :github_url, :status, :commit_count]
  table.hashes.each do |hash|
    project = default_test_author.projects.new(hash.except('author', 'tags'))
    project.save!
  end
end

Given(/^the document "([^"]*)" has a child document with title "([^"]*)"$/) do |parent, child|
  parent_doc = Document.find_by_title(parent)
  parent_doc.children.create!(
    {
      project_id: parent_doc.project_id,
      title: child,
      user_id: parent_doc.user_id
    }
  )
end

Then(/^I should become a member of project "([^"]*)"$/) do |name|
  object = Project.find_by_title(name)
  @user.follow(object)
end

When(/^I am a member of project "([^"]*)"$/) do |name|
  step %(I should become a member of project "#{name}")
end

When(/^"(.*)" is a member of project "([^"]*)"$/) do |name, project|
  user = User.find_by_first_name(name)
  object = Project.find_by_title(project)
  user.follow(object)
end

Then(/^I should stop being a member of project "([^"]*)"$/) do |name|
  object = Project.find_by_title(name)
  @user.stop_following(object)
end

When(/^I am not a member of project "([^"]*)"$/) do |name|
  step %(I should stop being a member of project "#{name}")
end

When(/^"(.*)" is not a member of project "([^"]*)"$/) do |name, project|
  user = User.find_by_first_name(name)
  object = Project.find_by_title(project)
  user.stop_following(object)
end

Given(/^I am on the home page$/) do
  visit root_path
end

Given(/^the document "([^"]*)" has a sub-document with title "([^"]*)" created (\d+) days ago$/) do |parent, child, days_ago|
  parent_doc = Document.find_by_title(parent)
  parent_doc.children.create!(
    {
      project_id: parent_doc.project_id,
      title: child,
      created_at: days_ago.to_i.days.ago,
      user_id: parent_doc.user_id
    }
  )
end

# Bryan: Redundant, does nothing
# And(/^the following sub-documents exist:$/) do |table|
#  table.hashes
# end

Then /^I should see a link "([^"]*)" that connects to the "([^"]*)"$/ do |text, url|
  project = Project.find_by title: text
  step %(I should see a link "#{text}" to "#{project.send url}")
end

Then /^I should see a link "([^"]*)" that connects to the issue tracker's url$/ do |link|
  project = Project.find_by title: link
  project.issue_trackers.each do |issue_tracker|
    expect(page).to have_link(link, href: issue_tracker.url)
  end
end

Given(/^I (should not|should) see a link to "(.*?)" on github$/) do |option, name|
  object = Project.find_by_title(name)
  step %(I #{option} see link "#{object.github_url.split('/').last}")
end

Given(/^The project "([^"]*)" has (\d+) (.*)$/) do |title, num, item|
  project = Project.find_by_title(title)
  case item.downcase.pluralize
  when 'members'
    (1..num.to_i).each do
      u = User.create(email: Faker::Internet.email, password: '1234567890')
      u.follow(project)
    end
  else
    pending
  end
end

Then(/^I should see (\d+) member avatars$/) do |count|
  within('#members-list') do
    expect(page).to have_css '.user-preview', count: count
  end
end

Then(/^I should see projects looked up by title with the correct commit count:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do |project|
    updated_project = Project.find_by_title(project['title'])
    expect(updated_project.commit_count).to eq(project['commit_count'].to_i)
  end
end

Then(/^I should see projects with pitch updated:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do |project|
    updated_project = Project.find_by_title(project['title'])
    expect(updated_project.pitch).to match(/#{project["pitch"]}/)
  end
end

Then(/^I should see projects looked up by title with first source repository same as github_url:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do |project|
    updated_project = Project.find_by_title(project['title'])
    expect(updated_project.github_url).to eq(project['github_url'])
    expect(updated_project.source_repositories.first.url).to eq(project['github_url'])
  end
end

Then(/^I should see projects with following updates:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do |project|
    updated_project = Project.find_by_title(project['title'])
    expect(updated_project.last_github_update).to eq(project['last_github_update'])
  end
end

Then(/^I should see projects with the following language updates:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do |project|
    updated_project = Project.find_by_title(project['title'])
    @updated_language_array = []
    updated_project.languages.each do |language|
      @updated_language_array << language.name if language.name.eql?(project[:languages])
    end
    expect(@updated_language_array).to include(project[:languages])
  end
end

Then(/^I should see a GPA of "([^"]*)" for "([^"]*)"$/) do |gpa, _project_name|
  within('ul#project-list') do
    expect(page).to have_css("li[title=\"#{gpa} CodeClimate GPA\"]")
  end
end

When(/^I go to the next page$/) do
  click_link 'Next →', match: :first
end

Given(/^that project "([^"]*)" has an extra repository "([^"]*)"$/) do |project_name, repo|
  project = Project.find_by_title(project_name)
  project.source_repositories.create(url: repo)
end

When(/^I go to the "([^"]*)" project "([^"]*)" page$/) do |title, page|
  id = Project.find_by(title: title).id
  visit path_to(page, id)
end

Given(/^"([^"]*)" creates the project "([^"]*)"$/) do |name, project_title|
  first_name, last_name = name.split
  user = User.create last_name: last_name, first_name: first_name, email: 'bob@example.org', password: 'asdf1234'
  Project.create title: project_title, description: 'Hello world', status: 'Active', user_id: user.id
end

Given(/^"([^"]*)" deactivates his account$/) do |name|
  first_name, last_name = name.split
  user = User.find_by first_name: first_name, last_name: last_name
  user.delete
end

Given(/^the anonymous user exists$/) do
  attributes = { id: -1, first_name: 'Anonymous', last_name: '', email: 'anonymous@example.org' }
  FactoryBot.create(:user, attributes)
end

Given('I should be able to create a project with more than one issue tracker') do
  visit path_to('new project')
  fill_in 'Title', with: 'Multiple issue tracker project'
  fill_in 'Description', with: 'has lots of code'
  fill_in 'GitHub url (primary)', with: 'http://www.github.com/new'
  fill_in 'Issue Tracker (primary)', with: 'http://www.waffle.com/new'
  click_link_or_button 'Add more trackers'
  expect(page).to have_text('Issue Tracker (2)')
  select 'Active', from: 'Status'
  click_button 'Submit'
  expect(page).to have_content('Multiple issue tracker project')
  expect(page).to have_content('has lots of code')
end

Given('project {string} is activated') do |title|
  project = Project.find_by title: title
  project.update status: 'active'
end

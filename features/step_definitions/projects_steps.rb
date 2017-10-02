Then(/^I should see "([^"]*)" table$/) do |legend|

  expect(page).to have_css 'h1', text: legend
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    if hash[:author].present?
      u = User.find_by_first_name hash[:author]
      project = Project.new(hash.except('author', 'tags').merge(user_id: u.id))
    else
      project = default_test_author.projects.new(hash.except('author', 'tags'))
    end
    if hash[:github_url].present?
      project.source_repositories.build(url: hash[:github_url])
    else
      project.source_repositories.build
    end
    if hash[:tags]
      project.tag_list.add(hash[:tags], parse: true)
    end
    project.save!
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
          :project_id => parent_doc.project_id,
          :title => child,
          user_id: parent_doc.user_id
      }
  )
end

Then(/^I should become a member of project "([^"]*)"$/) do | name|
  object = Project.find_by_title(name)
  @user.follow(object)
end

When(/^I am a member of project "([^"]*)"$/) do |name|
  step %Q{I should become a member of project "#{name}"}
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
  step %Q{I should stop being a member of project "#{name}"}
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
          :project_id => parent_doc.project_id,
          :title => child,
          :created_at => days_ago.to_i.days.ago,
          user_id: parent_doc.user_id
      }
  )
end

# Bryan: Redundant, does nothing
#And(/^the following sub-documents exist:$/) do |table|
#  table.hashes
#end

Given(/^I (should not|should) see a link to "(.*?)" on github$/) do |option, name|
  object = Project.find_by_title(name)
  step %Q{I #{option} see link "#{object.github_url.split('/').last}"}
end

Given(/^I (should not|should) see a link to "(.*?)" on Pivotal Tracker$/) do |option, name|
  object = Project.find_by_title(name)
  step %Q{I #{option} see link "#{object.title}"}
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
  within ('#members-list') do
    expect(page).to have_css '.user-preview', count: count
  end

end

Then(/^I should see projects looked up by title with the correct commit count:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do | project |
    updated_project = Project.find_by_title(project["title"])
    expect(updated_project.commit_count).to eq(project["commit_count"].to_i)
  end
end

Then(/^I should see projects looked up by title with first source repository same as github_url:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do | project |
    updated_project = Project.find_by_title(project["title"])
    expect(updated_project.github_url).to eq(project["github_url"])
    expect(updated_project.source_repositories.first.url).to eq(project["github_url"])
  end
end

Then(/^I should see projects with following updates:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  projects = table.hashes
  projects.each do | project |
    updated_project = Project.find_by_title(project["title"])
    expect(updated_project.last_github_update).to eq(project["last_github_update"])
  end
end

Then(/^I should see a GPA of "([^"]*)" for "([^"]*)"$/) do |gpa, project_name|
  within('ul#project-list') do
    expect(page).to have_css("li[title=\"#{gpa} CodeClimate GPA\"]")
  end
end

When(/^I go to the next page$/) do
  click_link "Next →", match: :first
end


Given(/^that project "([^"]*)" has an extra repository "([^"]*)"$/) do |project_name, repo|
  project = Project.find_by_title(project_name)
  project.source_repositories.create(url: repo)
end
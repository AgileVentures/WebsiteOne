When(/^I run the rake task for calculating karma points$/) do
  $rake["karma_calculator"].execute
end

When(/^I run the rake task for fetching github commits$/) do
  $rake["fetch_github_commits"].execute
end

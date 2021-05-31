# frozen_string_literal: true

Given(/^the following articles with votes exist:$/) do |table|
  table.hashes.each_with_index do |raw_hash, article_count|
    hash = {}
    votes = raw_hash['VoteValue']
    raw_hash.except! 'VoteValue'
    raw_hash.each_pair { |k, v| hash[k.to_s.downcase.squish.gsub(/\s+/, '_')] = v }
    article = default_test_author.articles.new hash
    article.save!
    votes.to_i.abs.times do |voter_count|
      user_email = "avoter_#{article_count}#{voter_count}@example.com"
      u = FactoryBot.create(:user, email: user_email)
      votes.to_i >= 0 ? article.upvote_from(u) : article.downvote_from(u)
    end
  end
end

Then(/^I should see a Vote value of "(.*?)"$/) do |vote_value|
  expect(page).to have_text "Votes: #{vote_value}"
end

Given(/^I have voted "(.*?)" article "(.*?)"$/) do |up_or_down, article|
  @article = Article.find_by_title(article)
  case up_or_down.downcase
  when 'up'
    @article.liked_by @current_user
  when 'down'
    @article.downvote_from @current_user
  end
end

Given(/^I have authored article "(.*?)"$/) do |title|
  @user = default_test_author
  step %(I am logged in as "#{@user.first_name}")
  @article = Article.find_by_title title
  @article ||= @user.articles.create({ title: title, content: 'An Author vote test article.' })
end

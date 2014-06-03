Given(/^the following articles with votes exist:$/) do |table|
  table.hashes.each do |raw_hash|
    hash = {}
    raw_hash.each_pair { |k, v| hash[k.to_s.downcase.squish.gsub(/\s+/, '_')] = v }
    votes = hash['votevalue']
    hash.except! 'votevalue'
    unique_value = hash['uniquevalue']
    hash.except! 'uniquevalue'
    if hash['author'].present?
      u = User.find_by_first_name hash['author']
      hash.except! ('author')
      article = u.articles.new hash
    else
      article = default_test_author.articles.new hash
    end
    article.save!

    votes.to_i.abs.times do |n|
      # create a voter so that a vote can be cast
      user_email = 'avoter_' + unique_value + n.to_i.to_s + '@example.com'
      create_test_user(:email => user_email)
      u = User.find_by_email user_email
      votes.to_i >= 0 ? article.upvote_from( u ) : article.downvote_from( u )
    end
  end

end

Then(/^I should see a Vote value of "(.*?)"$/) do |vote_value|
  page.should have_text 'Vote value: ' + vote_value
end

Given(/^I have voted "(.*?)" article "(.*?)"$/) do |up_or_down, article|

  @article = Article.find_by_title( article )

  case up_or_down.downcase
  when 'up'
    @article.upvote_by @current_user
  when 'down'
    @article.downvote_by @current_user
  else
    raise 'unkown vote type'
  end

end


Given(/^the following articles with votes exist:$/) do |table|
  table.hashes.each do |raw_hash|
    hash = {}
    raw_hash.each_pair { |k, v| hash[k.to_s.downcase.squish.gsub(/\s+/, '_')] = v }
    votes = hash['votevalue']
    hash.except! 'votevalue'
    if hash['author'].present?
      u = User.find_by_first_name hash['author']
      hash.except! ('author')
      article = u.articles.new hash
    else
      article = default_test_author.articles.new hash
    end

    votes.to_i.abs.times {| n |
      # create a voter so that a vote can be cast
      user_email = 'avoter' + n.to_i.to_s + '@example.com'
      create_test_user(:email => user_email)
      u = User.find_by_email user_email
      votes.to_i >= 0 ? article.upvote_from( u ) : article.downvote_from( u )
    }
    article.save!
  end

end

Then(/^I should see a Vote value of "(.*?)"$/) do |vote_value|
  page.should have_text 'Vote value: ' + vote_value
end

Given(/^I have( not)? voted "(.*?)" article "(.*?)"$/) do |negative, up_or_down, article|
# I think the negative should be dropped from parameter list,
# because 'not voting up' does not imply 'voting down'
# But we do want  'undo Vote up/down' Scenarios

  direction = up_or_down.downcase == 'up' ? 'up' : 'down'
  opposite_direction = direction == 'up' ? 'down' : 'up'

  unless negative
    case direction
      when 'up'
        @article.upvote_by @current_user
      when 'down'
        @article.downvote_by @current_user
      else
        raise.exception 'unkown vote type' # Incorrect Syntax to raise error on test ??
    end
  else
    # nothing to do
  end

end


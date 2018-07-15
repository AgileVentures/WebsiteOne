Then(/^I should have a valid authorized AVDashboard token on the rendered page$/) do
  expect(page.body).to have_css("p#token")
  encoded_token = page.find(:css, "p#token").text
  require 'jwt'
  decoded_token = JWT.decode encoded_token, Settings.av_dashboard_token_secret, 'HS256'
  expect(decoded_token).to include(hash_including("authorized" => "true"))
  expect(decoded_token).to include(hash_including("exp"))
  expect(DateTime.strptime(decoded_token.first['exp'], "%Q")).to be >= DateTime.now
  expect(DateTime.strptime(decoded_token.first['exp'], "%Q")).to be <= (DateTime.now + 1.day)
end

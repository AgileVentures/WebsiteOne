class KarmaCalculator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform
    user.karma_points = 0
    return if user.created_at.blank?

    user.karma_points = membership_length + profile_completeness + activity + number_hangouts_started_with_more_than_one_participant + number_github_contributions
    # better to have time in pairing sessions, code contributed (related to quality), issues, ...
  end

  private

  def membership_length # 6
    user.membership_length
  end

  def profile_completeness # 10
    awarded = user.profile_completeness
    awarded += user.authentications.count * 100
    return awarded
  end

  def number_github_contributions
    user.commit_count_total
  end

  def number_hangouts_started_with_more_than_one_participant
    user.number_hangouts_started_with_more_than_one_participant
  end

  def activity # 6
    user.activity
  end

end

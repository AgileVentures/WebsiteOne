class KarmaCalculator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform
    user.karma_points = 0
    return if user.created_at.blank? || user_age_in_months < 1

    user.karma_points = membership_length + profile_completeness + activity + number_pairing_sessions + number_github_contributions
    # better to have time in pairing sessions, code contributed (related to quality), issues, ...
  end

  private

  def membership_length # 6
    1 * [user_age_in_months.to_i, 6].min
  end

  def profile_completeness # 10
    awarded = 0
    awarded += 2 if user.skill_list.present?
    awarded += 2 if user.github_profile_url.present?
    awarded += 2 if user.youtube_user_name.present?
    awarded += 2 if user.bio.present?
    awarded += 1 if user.first_name.present?
    awarded += 1 if user.last_name.present?
    awarded += user.authentications.count * 100
    return awarded
  end

  def number_github_contributions
    user.commit_counts.inject(0){|memo,c| memo += c.commit_count}
  end

  def number_pairing_sessions
    user.event_instances.select { |h| h.participants != nil && h.participants.count > 1 }.count
  end

  def activity # 6
    2*[[(user.sign_in_count - 2), 0].max, 3].min
  end

  def user_age_in_months
    (DateTime.current - user.created_at.to_datetime).to_i / 30
  end
end

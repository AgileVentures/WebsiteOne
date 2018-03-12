class KarmaCalculator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform
    if user.karma
      user.karma.total = 0
    else
      user.karma = Karma.find_or_create_by(user_id: user.id, total: 0)
    end

    return if user.created_at.blank?
    user.karma.total = sum_elements
    # better to have time in pairing sessions, code contributed (related to quality), issues, ...
  end

  private

  def sum_elements
    membership_length + profile_completeness + activity + number_hangouts_started_with_more_than_one_participant + number_github_contributions + hangouts_attended_with_more_than_one_participant
  end

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

  def hangouts_attended_with_more_than_one_participant
    id = gplus_id
    return 0 unless id
    hangouts_attended = calculate_hangouts_attended_with_more_than_one_participant(id)
    user.hangouts_attended_with_more_than_one_participant = hangouts_attended
  end

  def gplus_id
    gplus_auth = user.authentications.select { |a| a.provider == 'gplus' }
    gplus_auth.try(:first).try(:uid)
  end

  def calculate_hangouts_attended_with_more_than_one_participant(id)
    EventInstance.all.select do |i|
      more_than_one?(i) && i.participants.to_unsafe_h.values.any? do |p|
        p['person']['id'] == id
      end
    end.count
  end

  def more_than_one?(event_instance)
    !event_instance.participants.nil? && event_instance.participants.to_unsafe_h.values.count > 1
  end

  def activity # 6
    user.activity
  end

end

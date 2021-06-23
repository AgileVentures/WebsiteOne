# frozen_string_literal: true

class KarmaCalculator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def calculate
    {
      hangouts_attended_with_more_than_one_participant: number_hangouts_started_with_more_than_one_participant,
      membership_length: membership_length,
      profile_completeness: profile_completeness,
      number_github_contributions: number_github_contributions,
      activity: activity,
      event_participation: event_participation,
      total: sum_elements
    }
  end

  private

  def sum_elements
    membership_length + profile_completeness + activity + number_hangouts_started_with_more_than_one_participant +
      number_github_contributions + event_participation
  end

  # 6
  def membership_length
    @membership_length ||= user.membership_length
  end

  # 10
  def profile_completeness
    @profile_completeness ||= begin
      awarded = user.profile_completeness
      awarded += user.authentications.count * 100
      awarded
    end
  end

  def number_github_contributions
    @number_github_contributions ||= user.commit_count_total
  end

  def number_hangouts_started_with_more_than_one_participant
    @number_hangouts_started_with_more_than_one_participant ||= user.number_hangouts_started_with_more_than_one_participant
  end

  # 6
  def activity
    @activity ||= user.activity
  end

  def event_participation
    @event_participation ||= user.event_participation_count
  end
end

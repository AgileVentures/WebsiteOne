# frozen_string_literal: true

json.array! @subscriptions do |subscription|
  json.email subscription.user.try(:email)
  json.sponsor_email subscription.sponsor.try(:email)
  json.started_on subscription.started_at.strftime('%Y-%m-%d')
  json.ended_on subscription.ended_at.try(:strftime, '%Y-%m-%d')
  json.plan_name subscription.plan.name
  json.payment_source subscription.payment_source.type
  # date_format = subscription.all_day_event? ? '%Y-%m-%d'
  # json.id subscription.id
  # json.title subscription.title
  # json.start subscription.start_date.strftime(date_format)
  # json.end subscription.end_date.strftime(date_format)
end

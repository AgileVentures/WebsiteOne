class Status < ActiveRecord::Base
  belongs_to :user

  validates :status, :user_id, presence: true

  OPTIONS = ['Ready to pair',
             'Doing code review',
             'Plz, do not disturb',
             'Waiting for next scrum...',
             'Sleeping at my keyboard']
end

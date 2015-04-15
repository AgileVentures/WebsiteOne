class Status < ActiveRecord::Base
  belongs_to :user, counter_cache: :status_count


  OPTIONS = ['Ready to pair',
             'Doing code review',
             'Plz, do not disturb',
             'Waiting for next scrum...',
             'Sleeping at my keyboard']

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: { in: OPTIONS }
end

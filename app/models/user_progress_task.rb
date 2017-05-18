class UserProgressTask < ActiveRecord::Base
  belongs_to :user
  include UserNullable

  belongs_to ProgressTask
end
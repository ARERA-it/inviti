class UserInteraction < ApplicationRecord
  belongs_to :user
  default_scope { includes(:user).order(created_at: :desc) }
end

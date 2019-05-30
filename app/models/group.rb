# == Schema Information
#
# Table name: groups
#
#  id         :bigint(8)        not null, primary key
#  name       :string(40)
#  in_use     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ApplicationRecord
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users, allow_destroy: true
  validates :name, presence: true
  validates :name, uniqueness: true

  after_validation :user_with_same_name

  def user_with_same_name
    if User.find_by(display_name: name)
      # a user exists with the same name
      self.errors.add(:name, "non può essere il nome di un utente")
    end
  end
end

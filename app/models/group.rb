# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  name        :string(40)
#  in_use      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ask_opinion :boolean          default(FALSE)
#  appointable :boolean
#

class Group < ApplicationRecord
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users, allow_destroy: true
  validates :name, presence: true
  validates :name, uniqueness: true
  validate :same_name_of_an_existing_group
  audited

  # after_validation :user_with_same_name

  def same_name_of_an_existing_group
    if User.find_by(display_name: name)
      # a user exists with the same name
      self.errors.add(:name, "non può essere il nome di un utente")
    end
  end

  # def user_with_same_name
  #   if User.find_by(display_name: name)
  #     # a user exists with the same name
  #     self.errors.add(:name, "non può essere il nome di un utente")
  #   end
  # end

  # return a array [[group_name, [users_name_array...]], ...]
  def Group.opinion_group_and_users
    Group.where(ask_opinion: true).includes(:users).map{|g| [g.name, g.users.map(&:display_name)]}
  end
end

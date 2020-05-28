# == Schema Information
#
# Table name: roles
#
#  id          :bigint           not null, primary key
#  name        :string
#  code        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Role < ApplicationRecord
  has_many :users
  has_many :permissions, -> { order(:controller, :action) }, dependent: :destroy
  accepts_nested_attributes_for :permissions
  validates :name, uniqueness: true
  validates :code, uniqueness: true, if: :code_not_nil?

  ABSTRACT  = 'abstract'
  GUEST     = 'guest'
  ADMIN     = 'admin'
  SUPERUSER = 'superuser'

  def abstract?
    code==ABSTRACT
  end

  def guest?
    code==GUEST
  end

  def code_not_nil?
    !code.nil?
  end

  def can?(controller, action)
    Permission.find_by(role_id: id, controller: controller, action: action)&.permitted || false
  end

  def set_all_to(bool)
    Permission.where(role_id: id).update_all(permitted: bool)
  end

  def Role.abstract
    Role.find_by(code: ABSTRACT)
  end

  def Role.concrete
    Role.where.not(code: ABSTRACT)
  end

  def Role.superuser
    Role.find_by(code: SUPERUSER)
  end

  def Role.admin
    Role.find_by(code: ADMIN)
  end

  def Role.guest
    r = Role.find_by(code: GUEST)
    if r.nil?
      r = Role.create(name: 'guest', code: GUEST)
      r.sync_roles
    end
    r
  end

  def sync_roles
    if abstract?
      # sync ALL concrete roles
      abstract_role_permissions = Permission.where(role_id: id)
      Role.concrete.each do |role|
        sync_one(abstract_role_permissions, role)
      end
    else
      # sync only current concrete roles
      abstract_role_permissions = Permission.where(role_id: Role.abstract.id)
      sync_one(abstract_role_permissions, self)
    end
  end

  def duplicate
    n = "#{self.name} copy"
    while !(r = Role.find_by(name: n)).nil?
      n = SecureRandom.hex.first(6)
    end
    r = Role.create(name: n, description: "")
    permissions.each do |p|
      r.permissions.create(controller: p.controller, action: p.action, permitted: p.permitted)
    end
    r
  end

  private

  def sync_one(abstract_role_permissions, role)
    current_role_permissions_ids = role.permissions.pluck(:id)
    abstract_role_permissions.each do |perm|
      p = Permission.find_or_create_by(role_id: role.id, controller: perm.controller, action: perm.action) do |p|
        p.permitted = perm.permitted
      end
      current_role_permissions_ids.delete(p.id)
    end
    # now delete orphan permissions
    if current_role_permissions_ids.any?
      Permission.where(id: current_role_permissions_ids).delete_all
    end
  end
end

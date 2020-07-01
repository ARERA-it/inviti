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
  has_many :users, dependent: :nullify
  # has_many :permissions, -> { order(:controller, :action) }, dependent: :destroy
  has_many :permission_roles, dependent: :destroy
  accepts_nested_attributes_for :permission_roles
  validates :name, uniqueness: true
  validates :code, uniqueness: true, if: :code_not_nil?
  before_save :set_code_if_nil

  GUEST     = 'guest'
  ADMIN     = 'admin'
  SUPERUSER = 'superuser'

  def Role.list
    Role.all.order(:name)
  end

  def trashable?
    !(guest? || admin? || superuser?)
  end

  def guest?
    code==GUEST
  end

  def admin?
    code==ADMIN
  end

  def superuser?
    code==SUPERUSER
  end

  def code_not_nil?
    !code.nil?
  end

  def can?(controller, action)
    return true if superuser?
    perm = Permission.find_by(controller: controller, action: action)
    return false if perm.nil?
    PermissionRole.find_by(role_id: id, permission_id: perm.id)&.permitted || false
  end

  def set_all_to(bool)
    Permission.where(role_id: id).update_all(permitted: bool)
  end

  def Role.superuser
    Role.find_by(code: SUPERUSER)
  end

  def Role.admin
    Role.find_by(code: ADMIN)
  end

  def Role.guest
    Role.find_by(code: GUEST)
  end

  # def sync_roles
  #   if abstract?
  #     # sync ALL concrete roles
  #     abstract_role_permissions = Permission.where(role_id: id)
  #     Role.all.each do |role|
  #       sync_one(abstract_role_permissions, role)
  #     end
  #   else
  #     # sync only current concrete roles
  #     abstract_role_permissions = Permission.where(role_id: Role.abstract.id)
  #     sync_one(abstract_role_permissions, self)
  #   end
  # end

  def duplicate
    n = "#{self.name} copy"
    while !(r = Role.find_by(name: n)).nil?
      n = SecureRandom.hex.first(6)
    end
    c = n.parameterize.underscore
    r = Role.create(name: n, code: c, description: "-- Copy of #{self.description}")

    Permission.all.each do |perm|
      bool = PermissionRole.find_by(role: self, permission: perm)&.permitted || false
      PermissionRole.create(role: r, permission: perm, permitted: bool)
    end
    r
  end

  def set_code_if_nil
    if code.nil?
      self.code = name.parameterize.underscore
    end
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

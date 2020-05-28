class ApplicationPolicy
  attr_reader :user, :record, :role

  def initialize(user, record)
    @user = user
    @record = record
    @role = user.role || Role.guest
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  class Scope
    attr_reader :user, :scope, :role

    def initialize(user, scope)
      @user = user
      @scope = scope
      @role = user.role || Role.guest
    end

    def resolve
      scope.all
    end
  end
end

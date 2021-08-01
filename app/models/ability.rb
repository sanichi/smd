class Ability
  include CanCan::Ability

  def initialize(user)
    can :gallery, Painting

    return if user.guest?

    can [:read, :update, :create], Painting
    can [:read, :update], Content

    return unless user.admin?

    can :manage, :all
  end
end

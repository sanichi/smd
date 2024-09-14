class Ability
  include CanCan::Ability

  def initialize(user)
    can :gallery, Painting
    can [:create, :subscribe, :unsubscribe], Contact

    return if user.guest?

    can [:read, :update, :create, :destroy, :archive], Painting
    can [:read, :update], Content
    can :manage, [Contact, Exhibit]

    return unless user.admin?

    can :manage, :all
  end
end

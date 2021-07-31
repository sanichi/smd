class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      if !user.guest?
        can :manage, :all
        cannot :manage, User
      end

      can :gallery, Painting
    end
  end
end

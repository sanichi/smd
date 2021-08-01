class Ability
  include CanCan::Ability

  def initialize(user)
    if user.guest?
      can :gallery, Painting
    else
      can :manage, :all
      unless user.admin?
        cannot :manage, User
        cannot :destroy, Painting
      end
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    case user.role
    when "admin"
      can :manage, :all
    when "member"
      can :read, :all
      can :create, [Favorite, Document, Comment, Download, Coin, Review, Organization, GroupMember]
      can :destroy, [Favorite, Document, Review, GroupMember], user_id: user.id
      can :manage, [Relationship, Team, Organization, GroupMember]
      can :update, [Review, Buycoin, GroupMember, Document], user_id: user.id
    else
      can :read, :all
    end
  end
end

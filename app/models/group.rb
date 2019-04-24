class Group < ApplicationRecord
  mount_base64_uploader :avatar, AvatarUploader
  has_paper_trail skip: [:avatar]

  has_many :memberships, inverse_of: :group, dependent: :destroy
  has_many :users, through: :memberships
  has_many :active_users, (lambda {
    where('start_date <= :now AND (end_date > :now OR
             memberships.end_date IS NULL)', now: Time.zone.now)
  }),
           through: :memberships, source: :user
  has_many :groups_permissions, class_name: 'GroupsPermissions', dependent: :destroy
  has_many :permissions, through: :groups_permissions
  has_many :mail_aliases

  scope :active, (lambda {
    joins(:memberships).merge(Membership.active).distinct
  })
  scope :active_groups_for_user, (lambda { |user|
    joins(:memberships).merge(Membership.active)
      .where('memberships.user_id = :user_id', user_id: user.id)
  })

  validates :name, presence: true
  validates :administrative, inclusion: [true, false]
  validates :kind, presence: true, inclusion: {
    in: %w[bestuur commissie dispuut genootschap groep huis jaargroep werkgroep kring lichting]
  }
end

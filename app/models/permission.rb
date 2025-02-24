class Permission < ApplicationRecord
  has_paper_trail
  has_many :groups_permissions, class_name: 'GroupsPermissions'
  has_many :permissions_users, class_name: 'PermissionsUsers'
  has_many :groups, through: :groups_permissions

  validates :name, presence: true, uniqueness: true
  validate :name_is_model_dot_action?

  private

  def name_is_model_dot_action?
    permission_name = name.try(:split, '.')
    errors.add(:name, "must be `model_name`.`action`, is `#{name}`") unless
                                                            permission_name.try(:length) == 2 &&
                                                            ApplicationRecord.model_names.include?(permission_name.first) && # rubocop:disable Layout/LineLength
                                                            %w[create read update destroy].include?(permission_name.second) # rubocop:disable Layout/LineLength
  end
end

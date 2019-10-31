bestuur   = Group.find_by(name: 'Bestuur')
ictcie    = Group.find_by(name: 'ICT-commissie')
members   = Group.find_by(name: 'Leden')
old_members = Group.find_by(name: 'Oud-Leden')

bestuur.permissions = []
ictcie.permissions  = []
members.permissions = []
old_members.permissions = []

def create_permissions(permission_map)
  permissions = []
  permission_map.each do |resource, actions|
    actions.each do |action|
      permissions << Permission.find_or_create_by!(name: "#{resource}.#{action}")
    end
  end
  permissions
end

all_permissions_map = {
  'user' => %i[create read update destroy],
  'activity' => %i[create read update destroy],
  'article' => %i[create read update destroy],
  'article_comment' => %i[create read update destroy],
  'board_room_presence' => %i[create read update destroy],
  'group' => %i[create read update destroy],
  'membership' => %i[create read update destroy],
  'poll' => %i[create read update destroy],
  'mail_alias' => %i[create read update destroy],
  'photo_album' => %i[create read update destroy],
  'photo' => %i[create read update destroy],
  'photo_comment' => %i[create read update destroy],
  'quickpost_message' => %i[create read update destroy],
  'quickpost_statistic' => [:read],
  'stored_mail' => %i[read destroy],
  'forum/category' => %i[create read update destroy],
  'forum/thread' => %i[create read update destroy],
  'forum/post' => %i[create read update destroy],
  'form/form' => %i[create read update destroy],
  'form/response' => %i[create read update destroy],
  'form/closed_question' => %i[create read update destroy],
  'form/closed_question_option' => %i[create read update destroy],
  'form/open_question' => %i[create read update destroy],
  'form/closed_question_answer' => %i[create read update destroy],
  'form/open_question_answer' => %i[create read update destroy],
  'permission' => [:read],
  'permissions_users' => %i[create destroy],
  'groups_permissions' => %i[create destroy],
  'static_page' => %i[create read update destroy],
  'debit/collection' => %i[create read update destroy],
  'debit/transaction' => %i[create read update destroy],
  'debit/mandate' => %i[create read update]
}

bestuur.permissions = create_permissions(all_permissions_map)
ictcie.permissions = create_permissions(all_permissions_map)

member_permission_map = {
  'user' => %i[read],
  'activity' => %i[create read],
  'article' => %i[create read],
  'article_comment' => %i[create read],
  'board_room_presence' => %i[read],
  'group' => %i[read],
  'membership' => %i[create],
  'poll' => %i[create read],
  'mail_alias' => %i[read],
  'photo_album' => %i[create read],
  'photo' => %i[create read],
  'photo_comment' => %i[create read],
  'quickpost_message' => %i[create read],
  'quickpost_statistic' => [:read],
  'forum/category' => %i[read],
  'forum/thread' => %i[create read],
  'forum/post' => %i[create read],
  'form/form' => %i[create read],
  'form/response' => %i[create read],
  'form/closed_question' => %i[create read],
  'form/closed_question_option' => %i[create read],
  'form/open_question' => %i[create read],
  'form/closed_question_answer' => %i[create read],
  'form/open_question_answer' => %i[create read],
  'permission' => [:read],
  'static_page' => %i[read],
  'debit/collection' => %i[read],
  'debit/transaction' => []
}

members.permissions = create_permissions(member_permission_map)

old_members_permission_map = {
  'user' => [],
  'activity' => %i[read],
  'article' => %i[read],
  'article_comment' => %i[create read],
  'board_room_presence' => %i[read],
  'group' => [],
  'poll' => [],
  'photo_album' => %i[read],
  'photo' => %i[read],
  'photo_comment' => %i[create read],
  'quickpost_message' => %i[create read],
  'quickpost_statistic' => [:read],
  'forum/category' => %i[read],
  'forum/thread' => %i[create read],
  'forum/post' => %i[create read],
  'form/form' => %i[read],
  'form/response' => %i[read],
  'form/closed_question' => %i[read],
  'form/closed_question_option' => %i[read],
  'form/open_question' => %i[read],
  'form/closed_question_answer' => %i[read],
  'form/open_question_answer' => %i[read],
  'permission' => [:read],
  'static_page' => %i[read]
}

old_members.permissions = create_permissions(old_members_permission_map)

member_group = Group.create!(name: 'Leden', kind: 'groep',
                             description: 'Alphanen, verenigt u!')

ictcie = Group.create!(name: 'ICT-commissie', kind: 'commissie',
                       description: 'Wij zijn gewoon bazen', recognized_at_gma: 'ALV 1')

bestuur = Group.create!(name: 'Bestuur', kind: 'bestuur', description: 'Wij zijn de echte bazen',
                        recognized_at_gma: 'ALV 21',  rejected_at_gma: 'ALV 218')

old_members_group = Group.create!(name: 'Oud-Leden', kind: 'groep',
                                  description: 'Oud-Alphanen, verenigt u!')

bestuurders = FactoryBot.create_list(:user, 6, activated_at: Time.zone.now)
bestuurders.first.update(username: 'bestuurder',
                         password: 'password1234',
                         password_confirmation: 'password1234')

leden = FactoryBot.create_list(:user, 90, activated_at: Time.zone.now)
leden.first.update(username: 'lid',
                   password: 'password1234',
                   password_confirmation: 'password1234')

nerds = FactoryBot.create_list(:user, 8, activated_at: Time.zone.now)
nerds.first.update(username: 'nerd',
                   password: 'password1234',
                   password_confirmation: 'password1234')

old_members = FactoryBot.create_list(:user, 8, activated_at: Time.zone.now)
old_members.first.update(username: 'oudlid',
                         password: 'password1234',
                         password_confirmation: 'password1234')

leden.each do |user|
  Membership.create(user: user, group: member_group, start_date: Date.current.months_ago(4),
                    function: Faker::Job.title)
end

nerds.each do |user|
  Membership.create(user: user, group: ictcie, start_date: Date.current.months_ago(10),
                    function: Faker::Job.title)
  Membership.create(user: user, group: member_group, start_date: Date.current.months_ago(4),
                    function: Faker::Job.title)
end

bestuurders.each do |user|
  Membership.create(user: user, group: bestuur, start_date: Date.current.months_ago(10),
                    function: Faker::Job.title)
  Membership.create(user: user, group: member_group, start_date: Date.current.months_ago(11),
                    function: Faker::Job.title)
end

old_members.each do |user|
  Membership.create(user: user, group: old_members_group, start_date: Date.current.months_ago(10),
                    function: Faker::Job.title)
end

FactoryBot.create_list(:group, 6, kind: 'kiemgroep',
                                  users: leden.sample(6))

FactoryBot.create_list(:group, 3, kind: 'huis',
                                  users: leden.sample(5))

FactoryBot.create_list(:group, 3, kind: 'dispuut',
                                  users: leden.sample(15))

FactoryBot.create_list(:group, 3, kind: 'werkgroep',
                                  users: leden.sample(3))

FactoryBot.create_list(:group, 3, kind: 'genootschap',
                                  users: leden.sample(10))

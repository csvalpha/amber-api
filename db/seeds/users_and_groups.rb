member_group = Group.create!(name: 'Leden', kind: 'groep',
                             description: 'Alphanen, verenigt u!')

ictcie = Group.create!(name: 'ICT-commissie', kind: 'commissie',
                       description: 'Wij zijn gewoon bazen', recognized_at_gma: 'ALV 1')

bestuur = Group.create!(name: 'Bestuur', kind: 'bestuur', description: 'Wij zijn de echte bazen',
                        recognized_at_gma: 'ALV 21', rejected_at_gma: 'ALV 218')

sofia_treasurers = Group.create!(name: 'SOFIA Penningmeester', kind: 'bestuur',
                                 administrative: true)

sofia_renting_managers = Group.create!(name: 'SOFIA Verhuur Manager', kind: 'bestuur',
                                       administrative: true)

sofia_main_bartenders = Group.create!(name: 'SOFIA Hoofdtappers', kind: 'groep')

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

sofia_treasurer = FactoryBot.create(:user, activated_at: Time.zone.now)
sofia_treasurer.update(username: 'sofia_treasurer',
                       password: 'password1234',
                       password_confirmation: 'password1234')

sofia_renting_manager = FactoryBot.create(:user, activated_at: Time.zone.now)
sofia_renting_manager.update(username: 'sofia_renting_manager',
                             password: 'password1234',
                             password_confirmation: 'password1234')

sofia_bartenders = FactoryBot.create_list(:user, 6, activated_at: Time.zone.now)
sofia_bartenders.first.update(username: 'sofia_main_bartender',
                              password: 'password1234',
                              password_confirmation: 'password1234')

old_members = FactoryBot.create_list(:user, 8, activated_at: Time.zone.now)
old_members.first.update(username: 'oudlid',
                         password: 'password1234',
                         password_confirmation: 'password1234')

leden.each do |user|
  Membership.create(user:, group: member_group, start_date: Date.current.months_ago(4),
                    function: Faker::Job.title)
end

nerds.each do |user|
  Membership.create(user:, group: ictcie, start_date: Date.current.months_ago(10),
                    function: Faker::Job.title)
  Membership.create(user:, group: member_group, start_date: Date.current.months_ago(4),
                    function: Faker::Job.title)
end

bestuurders.each do |user|
  Membership.create(user:, group: bestuur, start_date: Date.current.months_ago(10),
                    function: Faker::Job.title)
  Membership.create(user:, group: member_group, start_date: Date.current.months_ago(11),
                    function: Faker::Job.title)
end

Membership.create(user: sofia_treasurer, group: sofia_treasurers,
                  start_date: Date.current.months_ago(10))
Membership.create(user: sofia_treasurer, group: member_group,
                  start_date: Date.current.months_ago(4), function: Faker::Job.title)

Membership.create(user: sofia_renting_manager, group: sofia_renting_managers,
                  start_date: Date.current.months_ago(10))
Membership.create(user: sofia_renting_manager, group: member_group,
                  start_date: Date.current.months_ago(4), function: Faker::Job.title)

sofia_bartenders.each do |user|
  Membership.create(user:, group: sofia_main_bartenders,
                    start_date: Date.current.months_ago(10), function: Faker::Job.title)
  Membership.create(user:, group: member_group, start_date: Date.current.months_ago(4),
                    function: Faker::Job.title)
end

old_members.each do |user|
  Membership.create(user:, group: old_members_group, start_date: Date.current.months_ago(10),
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

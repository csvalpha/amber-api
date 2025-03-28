# rubocop:disable Style/CombinableLoops
members = Group.find_by(name: 'Leden').users

members.sample(4).each do |user|
  FactoryBot.create(:study_room_presence, user:)
end

articles = members.sample(15).map do |user|
  FactoryBot.create(:article, author: user, group: nil)
end

members.sample(5).each do |user|
  articles << FactoryBot.create(:article, author: user, group: user.groups.first)
end

members.sample(5).each do |user|
  articles << FactoryBot.create(
    :article,
    :public,
    author: user,
    group: nil
  )
end

members.sample(5).each do |user|
  articles << FactoryBot.create(
    :article,
    :public,
    author: user,
    group: user.groups.first
  )
end

articles << FactoryBot.create(
  :article,
  :pinned,
  author: members.first,
  group: nil
)

articles.each do |article|
  members.sample(6).each do |user|
    FactoryBot.create(:article_comment, article:, author: user)
  end
end

members.sample(4).each do |user|
  FactoryBot.create(:activity, author: user)
end

members.sample(4).each do |user|
  FactoryBot.create(:activity, :public, author: user)
end

activities_with_forms = members.sample(4).map do |user|
  FactoryBot.create(:activity, :with_form, author: user)
end

members.sample(4).each do |user|
  activities_with_forms << FactoryBot.create(:activity, :public, :with_form, author: user)
end

activities_with_forms.each do |activity|
  open_questions = FactoryBot.create_list(:open_question, 2, form: activity.form)
  closed_questions = FactoryBot.create_list(:closed_question, 4, form: activity.form)

  closed_questions.each do |question|
    FactoryBot.create_list(:closed_question_option, 3, question:)
  end

  members.sample(3).each do |user|
    response = FactoryBot.create(:response, form: activity.form, user:)

    closed_questions.each do |question|
      FactoryBot.create(:closed_question_answer, option: question.options.sample,
                                                 response:)
    end

    open_questions.each do |open_question|
      FactoryBot.create(:open_question_answer, question: open_question, response:)
    end
  end
end

polls_with_forms = members.sample(4).map do |user|
  FactoryBot.create(:poll, author: user)
end

polls_with_forms.each do |poll|
  closed_questions = FactoryBot.create_list(:closed_question, 1, form: poll.form)

  closed_questions.each do |question|
    FactoryBot.create_list(:closed_question_option, 3, question:)
  end

  members.sample(3).each do |user|
    response = FactoryBot.create(:response, form: poll.form, user:)

    closed_questions.each do |question|
      FactoryBot.create(:closed_question_answer, option: question.options.sample,
                                                 response:)
    end
  end
end

forum_threads = []
forum_posts = []

forum_categories = FactoryBot.create_list(:category, 7)

forum_categories.each do |category|
  members.sample(4).each do |member|
    forum_threads << FactoryBot.create(:thread, author: member, category:)
  end
end

forum_threads.each do |thread|
  forum_posts << FactoryBot.create(:post, thread:, author: thread.author)
  members.sample(24).each do |member|
    forum_posts << FactoryBot.create(:post, thread:, author: member)
  end
end

bestuur = Group.find_by(name: 'Bestuur').users

bestuur.each do |user|
  FactoryBot.create(:board_room_presence, user:)
end

FactoryBot.create_list(:static_page, 3)
FactoryBot.create_list(:static_page, 3, :public)

collections = FactoryBot.create_list(:collection, 4)

collections.each do |collection|
  members.sample(8).each do |member|
    FactoryBot.create(:transaction, collection:, user: member)
  end
end

members.sample(10).each do |member|
  FactoryBot.create(:mandate, user: member)
end

members.sample(10).each do |member|
  FactoryBot.create(:mail_alias, user: member)
end

members.sample(10).each do |member|
  FactoryBot.create(:mail_alias, user: nil, group: member.groups.first)
end

FactoryBot.create_list(:book, 10)
# rubocop:enable Style/CombinableLoops

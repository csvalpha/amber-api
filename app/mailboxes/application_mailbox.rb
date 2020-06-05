class ApplicationMailbox < ActionMailbox::Base
  routing :all => :moderated
end

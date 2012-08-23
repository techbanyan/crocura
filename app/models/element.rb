class Element < ActiveRecord::Base
  attr_accessible :privacy, :help, :faq, :how_it_works, :about
end

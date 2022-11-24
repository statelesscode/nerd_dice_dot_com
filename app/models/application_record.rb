# This is the abstract model class that all other models in the
# application inherit from
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

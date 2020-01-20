class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # since we are using uuid it is best to order table based on created_at
  self.implicit_order_column = "created_at"
end

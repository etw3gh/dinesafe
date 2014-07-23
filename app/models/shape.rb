class Shape < ActiveRecord::Base
  self.primary_key = 'timestamp'
  has_many :addresses, dependent: :destroy
end
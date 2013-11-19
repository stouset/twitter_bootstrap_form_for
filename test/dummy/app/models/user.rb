class User < ActiveRecord::Base
  validates :name, :email, presence: true
end

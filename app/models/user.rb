# Devise User Model
#
# The functionality for this model should be limited to user
# authentication. User preferences, avatars, etc. should be in a has_one
# related model like a profile, etc.
#
# The primary key of this model is a UUID, not a BigInt
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
end

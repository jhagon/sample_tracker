class User < ActiveRecord::Base
  has_many :samples
  belongs_to :group
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :group_id, :firstname, :lastname, :admin, :leader
  cattr_accessor :current_user
end

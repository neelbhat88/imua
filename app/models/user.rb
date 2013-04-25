class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # role: 0-student, 1-teacher, 2-admin
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  					:role, :user_info_id


  # attr_accessible :title, :body

  has_many :user_classes
  has_many :user_badges
  has_one :user_info, :dependent => :destroy

  def is_admin?    
    return (self.role == 2)
  end

  def is_student?
    return (self.role == 0)
  end

  def is_teacher?
    return (self.role == 1)
  end
end

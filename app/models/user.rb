  class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # Setup accessible (or protected) attributes for your model
  # role: 0-student, 1-teacher, 2-admin
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  					:role, :first_name, :last_name

  # attr_accessible :title, :body

  has_many :user_classes
  has_many :user_badges
  has_many :user_activities
  has_many :user_services
  has_many :user_pdus
  has_many :user_testings
  has_many :user_semester_gpas
  has_many :user_deductions
  has_many :user_practice_tests
  
  has_one :user_info, :dependent => :destroy  

  def is_student?
    return (self.role == 50)
  end

  def is_parent?
    return (self.role == 40)
  end

  def is_mentor?
    return (self.role == 30)
  end

  def is_student_admin?
    return (self.role == 20)
  end

  def is_school_admin?
    return (self.role == 10)
  end

  def is_super_admin?
    return (self.role == 0)
  end

##################
# Static methods
##################
  def self.GetRoleText(role)
    role_array = ['Student', 'Teacher', 'Admin']

    return role_array[role.to_i]
  end  
end

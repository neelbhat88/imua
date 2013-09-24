class AddIndexesToTables < ActiveRecord::Migration
  def change
  	add_index :user_info, :user_id, :name => 'IDX_UserInfo_UserId'
  	add_index :user_classes, :user_id, :name => 'IDX_UserClass_UserId'
  	add_index :user_activities, :user_id, :name => 'IDX_UserActivity_UserId'
  	add_index :user_services, :user_id, :name => 'IDX_UserService_UserId'
  	add_index :user_pdus, :user_id, :name => 'IDX_UserPdu_UserId'
  	add_index :user_badges, :user_id, :name => 'IDX_UserBadge_UserId'
  	add_index :user_testings, :user_id, :name => 'IDX_UserTesting_UserId'
  	add_index :user_semester_gpas, :user_id, :name => 'IDX_UserSemsterGpa_UserId'

	add_index :school_classes, :school_id, :name => 'IDX_SchoolClass_SchoolId'
	add_index :school_activities, :school_id, :name => 'IDX_SchoolActivity_SchoolId'
	add_index :school_pdus, :school_id, :name => 'IDX_SchoolPdu_SchoolId'

  	add_index :user_activities, :school_activity_id, :name => 'IDX_UserActivity_SchoolActivityId'
  	add_index :user_badges, :global_badge_id, :name => 'IDX_UserBadge_GlobalBadgeId'
  	add_index :user_classes, :school_class_id, :name => 'IDX_UserClass_SchoolClassId'
  	add_index :user_info, :school_id, :name => 'IDX_UserInfo_SchoolId'
  	add_index :user_pdus, :school_pdu_id, :name => 'IDX_UserPdu_SchoolPduId'
  	add_index :user_testings, :global_exam_id, :name => 'IDX_UserTesting_GlobalExamId'
  end
end

class UserPduAddSchoolPduId < ActiveRecord::Migration
  def change
  	add_column :user_pdus, :school_pdu_id, :integer
  	remove_column :user_pdus, :name
  end
end

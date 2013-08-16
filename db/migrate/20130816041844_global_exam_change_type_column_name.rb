class GlobalExamChangeTypeColumnName < ActiveRecord::Migration
  def change
  	rename_column :global_exams, :type, :exam_type
  end
end

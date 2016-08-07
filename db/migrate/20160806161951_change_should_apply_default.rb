class ChangeShouldApplyDefault < ActiveRecord::Migration
  def change
    change_column_default :job_applications, :should_apply, true 
  end
end

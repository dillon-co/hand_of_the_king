class AddShouldApplyToJobApplications < ActiveRecord::Migration
  def change
    add_column :job_applications, :should_apply, :boolean
  end
end

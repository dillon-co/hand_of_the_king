class CreateJobLinks < ActiveRecord::Migration
  def change
    create_table :job_links do |t| 

      t.string :job_title

      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end

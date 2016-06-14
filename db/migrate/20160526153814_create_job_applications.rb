class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|

      t.string :user_name
      t.string :user_email
      t.string :user_phone_number
      t.string :user_resume_path
      t.string :user_cover_letter

      t.string :indeed_link
      t.string :title
      t.string :company
      t.string :location
      t.string :pay_rate

      t.boolean :applied_to, default: false

      t.integer :pay_type

      t.text   :description

      t.belongs_to :job_link, index: true

      t.timestamps null: false
    end
  end
end

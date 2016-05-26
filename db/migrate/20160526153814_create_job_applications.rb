class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|

      t.string :title
      t.string :company
      t.string :loaction
      t.string :pay_rate

      t.integer :pay_type

      t.text   :description

      t.belongs_to :job_link, index: true

      t.timestamps null: false
    end
  end
end

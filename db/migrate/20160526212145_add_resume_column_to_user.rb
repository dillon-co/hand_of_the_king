class AddResumeColumnToUser < ActiveRecord::Migration
  def up
    add_attachment :users, :resume, null: false
  end

  def down
    remove_attachment :users, :resume
  end  
end

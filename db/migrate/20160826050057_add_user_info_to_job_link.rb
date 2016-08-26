class AddUserInfoToJobLink < ActiveRecord::Migration
  def change
    add_column  :job_links, :user_first_name,   :string
    add_column  :job_links, :user_last_name,    :string
    add_column  :job_links, :user_email,        :string
    add_column  :job_links, :user_phone_number, :string
    add_column  :job_links, :user_cover_letter, :string

    add_attachment :job_links, :user_resume
  end
end

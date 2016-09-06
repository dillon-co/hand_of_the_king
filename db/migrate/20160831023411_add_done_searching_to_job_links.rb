class AddDoneSearchingToJobLinks < ActiveRecord::Migration
  def change
    add_column :job_links, :done_searching, :boolean
  end
end

class AddCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credits, :integer, default: 2
  end
end

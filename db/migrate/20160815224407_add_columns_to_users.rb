class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_code, :string
    add_column :users, :referral_code, :string
    add_column :users, :referred_users_purchases_count, :integer
    add_column :users, :current_discount, :string
  end
end

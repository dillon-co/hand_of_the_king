class AddMoneyEarnedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :money_earned, :integer
  end
end

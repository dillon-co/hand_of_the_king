class ChangeUserCreditsDefault < ActiveRecord::Migration
  def change
    change_column_default :users, :credits, 1
  end
end

class AddSubsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subs, :string
  end
end

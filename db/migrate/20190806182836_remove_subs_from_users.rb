class RemoveSubsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :subs, :string
  end
end

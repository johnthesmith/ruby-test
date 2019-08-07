class AddNewCountEditToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :count_edit, :int, :null => false, :default => 0
  end
end

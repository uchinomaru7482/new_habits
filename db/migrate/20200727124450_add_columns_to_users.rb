class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, after: :email
    add_column :users, :image, :string, after: :name
  end
end

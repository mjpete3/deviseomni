class AddToUsers < ActiveRecord::Migration
  
  # add the columns for capturing facebook information
  
  def up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :timezone, :integer
    add_column :users, :location, :string
    add_column :users, :image, :string
    add_column :users, :profile, :string
  end

  def down
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :timezone
    remove_column :users, :location
    remove_column :users, :image
    remove_column :users, :profile
  end
end

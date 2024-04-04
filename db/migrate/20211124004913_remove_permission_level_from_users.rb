class RemovePermissionLevelFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :permission_level, :string
  end
end

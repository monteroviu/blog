class AddCoverTo < ActiveRecord::Migration[5.2]
  def change
    add_attachment :articles, :cover
  end
end

class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :visits_count
      #t.integer :visits_count, null: false, default: 0
      t.timestamps
    end
  end
end

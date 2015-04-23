class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    	t.belongs_to :list, index: true
      t.string :content
      t.timestamps null: false
    end
  end
end

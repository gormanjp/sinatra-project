class ItemUpdate < ActiveRecord::Migration
  def change
  	add_column :items, :list_id, :integer
  end
end

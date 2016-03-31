class UpdateItems < ActiveRecord::Migration
  def change
  	add_column :items, :checks, :integer
  end
end

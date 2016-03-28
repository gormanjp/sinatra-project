class CreateItems < ActiveRecord::Migration
  def change
  	create_table :items do |t|
  		t.string :content
  		t.integer :frequency
  	end
  end
end

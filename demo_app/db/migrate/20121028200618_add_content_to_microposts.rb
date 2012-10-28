class AddContentToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :content, :string
  end
end

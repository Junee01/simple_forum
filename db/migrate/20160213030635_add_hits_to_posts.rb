class AddHitsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hits, :integer, :default => 0
  end
end

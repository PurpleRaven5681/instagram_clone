class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :follower_id
      t.integer :following_id
      t.timestamps
    end
    
    add_index :subscriptions, :follower_id
    add_index :subscriptions, :following_id
    add_index :subscriptions, [:follower_id, :following_id], unique: true
  end
end

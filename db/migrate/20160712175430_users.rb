class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :email
      t.string :photo

      t.timestamps null: false
    end
  end
end

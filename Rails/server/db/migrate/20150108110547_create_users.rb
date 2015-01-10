class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text "device_uuid"
      t.text "token"
      t.timestamps
    end
  end
end

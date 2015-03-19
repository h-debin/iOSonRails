class AddTimeStampToNews < ActiveRecord::Migration
  def change
    add_column :news, :created_at, :date_time
    add_column :news, :updated_at, :date_time
  end
end

class ChangeDataTypeOfEmotionValue < ActiveRecord::Migration
  def change
    change_column :news, :le,  :integer
    change_column :news, :hao, :integer
    change_column :news, :nu, :integer
    change_column :news, :ai, :integer
    change_column :news, :ju, :integer
    change_column :news, :e, :integer
    change_column :news, :jing, :integer
  end
end

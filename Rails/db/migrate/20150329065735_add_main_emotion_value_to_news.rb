class AddMainEmotionValueToNews < ActiveRecord::Migration
  def change
    add_column :news, :main_emotion_value, :integer
  end
end

class AddEmotionTypeToNews < ActiveRecord::Migration
  def change
    add_column :news, :emotion_type, :text
  end
end

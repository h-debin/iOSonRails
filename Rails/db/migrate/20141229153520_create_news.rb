class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.text "title"
      t.text "link"
      t.datetime "pub_date"
      t.text "image"
      t.text "video"
      t.text "category"
      t.text "from_site"
      t.text "text"

      t.timestamps
    end
  end
end

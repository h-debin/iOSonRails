class UpdateSchema < ActiveRecord::Migration
  def change
    create_table "news", force:true do |table|
      table.text "title"
      table.text "description"
      table.text "guid"
      table.datetime "pub_date"
      table.text "link"
      table.text "category"
      table.text "picture"
      table.text "le"
      table.text "hao"
      table.text "nu"
      table.text "ai"
      table.text "ju"
      table.text "e"
      table.text "jing"
    end
  end
end

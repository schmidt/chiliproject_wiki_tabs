class CreateWikiTabs < ActiveRecord::Migration
  def self.up
    create_table :wiki_tabs do |t|
      t.column :active, :boolean, :null => false
      t.column :name, :string
      t.column :title, :string

      t.belongs_to :wiki
    end
  end

  def self.down
    drop_table :wiki_tabs
  end
end

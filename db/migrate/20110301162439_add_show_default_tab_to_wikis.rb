class AddShowDefaultTabToWikis < ActiveRecord::Migration
  def self.up
    change_table :wikis do |t|
      t.column :show_default_tab, :boolean, :null => false, :default => true
    end
  end

  def self.down
    change_table :wikis do |t|
      t.remove :show_default_tab
    end
  end
end

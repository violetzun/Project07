class ChangeDataTypeForEntriesContent < ActiveRecord::Migration
  	  def self.up
    change_table :entries do |t|
      t.change :content, :Text
    end
  end
 
  def self.down
    change_table :entries do |t|
      t.change :content, :String
    end
  end

end

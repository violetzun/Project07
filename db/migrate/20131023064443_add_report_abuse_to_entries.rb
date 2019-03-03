class AddReportAbuseToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :report_abuse, :integer
  end
end

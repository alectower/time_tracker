Sequel.migration do
  change do
    alter_table :entry_logs do
      rename_column :start_time, :started_at
      rename_column :stop_time, :ended_at
      rename_column :description, :entry_description
    end
  end
end

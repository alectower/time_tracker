require 'sequel'
require 'yaml'

module TimeTracker
  class DB

    def self.connect
      db = Sequel.connect "sqlite://#{path}"
      create_table(db) unless db.table_exists? :entry_logs
      db
    end

    def self.path
      conf_file = "../../../database.yml"
      conf_path = File.expand_path conf_file, __FILE__
      config = YAML::load(File.open(conf_path))
      env = ENV['TT_ENV'] || 'production'
      File.expand_path(config[env]['database'])
    end

    private

    def self.create_table(db)
      db.create_table :entry_logs do
        primary_key :id
        String      :project_name, size: 50
        String      :task_name, size: 50
        String      :entry_description
        DateTime    :started_at
        DateTime    :ended_at
        Integer     :project_id
        Integer     :task_id
        Integer     :entry_id
        Integer     :entry_log_id
      end
    end
  end
end

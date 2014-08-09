require 'sqlite3'
require 'yaml'

module TimeTracker
  class DB
    def initialize
      @env = ENV['TT_ENV'] || 'production'
      @db = SQLite3::Database.new(path)
      create_table unless table_exists?('entry_logs')
      @db.results_as_hash = true
    end

    def execute(sql, args = [])
      @db.execute sql, args
    end

    def path
      return @path if @path
      conf_file = "../../../database.yml"
      conf_path = File.expand_path conf_file, __FILE__
      config = YAML::load(File.open(conf_path))
      @path = File.expand_path(config[@env]['database'])
    end

    def table_exists?(table)
      execute("SELECT name FROM sqlite_master
        WHERE type='table' AND name='#{table}'").
          size > 0;
    end

    private

    def create_table
      @db.execute <<-SQL
        create table entry_logs (
          id integer primary key autoincrement,
          project_name varchar(50),
          task_name varchar(50),
          description varchar(100),
          start_time timestamp,
          stop_time timestamp,
          project_id int,
          task_id int,
          entry_id int,
          entry_log_id int
        );
      SQL
    end
  end
end

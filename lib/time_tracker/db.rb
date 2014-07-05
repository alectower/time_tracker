require 'sqlite3'
require 'yaml'

module TimeTracker
  class DB
    def initialize
      @env = ENV['TT_ENV'] || 'production'
      if !File.exists?(path)
        @db = SQLite3::Database.new(path)
        setup
      end
      @db = SQLite3::Database.new(path)
      @db.results_as_hash = true
    end

    def execute(sql, args = [])
      @db.execute sql, args
    end

    def path
      return @path if @path
      config = YAML::load(File.open(
        File.expand_path "../../../database.yml", __FILE__
      ))
      @path = File.expand_path(config[@env]['database'])
    end

    private

    def setup
      @db.execute <<-SQL
        create table entry_logs (
          id integer primary key autoincrement,
          start_time timestamp,
          stop_time timestamp,
          entry_id int,
          description varchar(100),
          task_id int,
          task_name varchar(50),
          project_id int,
          project_name varchar(50)
        );
      SQL
    end
  end
end

require_relative 'db'

module TimeTracker
  class EntryLog

    attr_accessor :id, :start_time, :stop_time,
      :description, :task_name, :project_name,
      :entry_log_id, :entry_id, :task_id, :project_id

    def initialize(args)
      args.each do |k, v|
        if !k.is_a? Integer
          instance_variable_set "@#{k.to_s}", v
        end
      end
    end

    def save
      if EntryLog.find(id)
        update
      else
        insert
      end
    end

    def self.find(id)
      res = db.execute "select * from entry_logs
        where id = ?", id
      res.size > 0 ? new(res.first) : false
    end

    def self.where(args)
      sql = select.dup
      params = []
      first = true
      args.each do |k, v|
        add_param(sql, params, k, v, first) if !v.nil?
        first = false
      end
      results = []
      res = db.execute(sql, params)
      res.each do |r|
        results << new(r)
      end
      results
    end

    def self.unsynced
      res = db.execute "select * from entry_logs where
        project_id is null
        or task_id is null
        or entry_id is null
        or entry_log_id is null order by id"
      results = []
      res.each do |r|
        results << new(r)
      end
      results
    end

    private

    def insert
      EntryLog.db.execute "insert into entry_logs
        (start_time, stop_time, description, task_name,
          project_name, entry_log_id, entry_id,
          task_id, project_id
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", [
          start_time,
          stop_time,
          description,
          task_name.to_s,
          project_name.to_s,
          entry_log_id,
          entry_id,
          task_id,
          project_id
        ]
      res = EntryLog.db.execute('select * from entry_logs where id = (select last_insert_rowid())').first
      EntryLog.new(res)
    end

    def update
      EntryLog.db.execute "update entry_logs set
        start_time = ?,
        stop_time = ?,
        description = ?,
        task_name = ?,
        project_name = ?,
        entry_log_id = ?,
        entry_id = ?,
        task_id = ?,
        project_id = ?
        where id = ?", [
          start_time,
          stop_time,
          description,
          task_name.to_s,
          project_name.to_s,
          entry_log_id,
          entry_id,
          task_id,
          project_id,
          id
        ]
      EntryLog.find(id)
    end

    def self.add_param(sql, params, k, v, first)
      if v =~ /null/
        sql << where_clause(k, v, first)
      else
        sql << where_clause(k, nil, first)
        params << v
      end
    end

    def self.where_clause(key, null, first)
      sql = first ? " where" : " and"
      if is_time?(key)
        sql << set_time_param(key, null)
      else
        sql << set_param(key, null)
      end
    end

    def self.set_time_param(key, null)
      if null.nil?
        " #{key} #{time_comparator(key)} ?"
      else
        " #{key} #{null}"
      end
    end

    def self.set_param(key, null)
      if null.nil?
        " #{key} = ?"
      else
        " #{key} #{null}"
      end
    end

    def self.is_time?(key)
      key =~ /time/
    end

    def self.time_comparator(key)
      key =~ /start/ ? ">" : "<"
    end

    def self.db
      @db ||= DB.new
    end

    def self.select
      @select ||= "select * from entry_logs"
    end
  end
end

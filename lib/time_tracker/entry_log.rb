require_relative 'db'

module TimeTracker
  class EntryLog

    attr_reader :id, :start_time, :stop_time, :entry_id,
      :description, :task_id, :task_name, :project_id,
      :project_name

    def self.insert(args)
      db.execute "insert into entry_logs
        (start_time, stop_time, entry_id,
          description, task_id, task_name,
          project_id, project_name
        ) values (?, ?, ?, ?, ?, ?, ?, ?)", [
          args[:start_time],
          args[:stop_time],
          args[:entry_id],
          args[:description],
          args[:task_id],
          args[:task_name].to_s,
          args[:project_id],
          args[:project_name].to_s
        ]
      id = db.execute("select last_insert_rowid()").
        first[0]
      res = db.execute('select * from entry_logs where id = ?', id).first
      new(res)
    end

    def self.update(args)
      db.execute "update entry_logs
        set stop_time = ?
        where id = ?", [
          args[:stop_time],
          args[:id]
        ]
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

    private

    def initialize(args)
      @id = args['id']
      @start_time = args['start_time']
      @stop_time = args['stop_time']
      @entry_id = args['entry_id']
      @description = args['description']
      @task_id = args['task_id']
      @task_name = args['task_name'].to_s
      @project_id = args['project_id']
      @project_name = args['project_name'].to_s
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

require 'yaml/store'
require_relative '../lib/time_tracker/db'

module TimeTracker
  class EntryImport
    def self.run(file)
      db = DB.new
      db.execute "delete from entry_logs"
      store = YAML::Store.new(file)
      store.transaction true do |s|
        s.roots.each do |prj|
          s[prj].each do |t, logs|
            logs.each_slice(2) do |l|
              db.execute "insert into entry_logs \
                (start_time, stop_time, entry_id, \
                  description, task_id, task_name, \
                  project_id, project_name\
                ) values (?, ?, ?, ?, ?, ?, ?, ?)", [
                  l[0].to_i, l[1].to_i,
                  nil, 'general',
                  nil, t.to_s,
                  nil, prj.to_s
                ]
            end
          end
        end
      end
    end
  end
end

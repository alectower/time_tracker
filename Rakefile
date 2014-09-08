require 'yaml'

desc "Migrate yaml store to db"
task :entry_import, [:file] do |task, args|
  require_relative 'tasks/entry_import'
  file = File.expand_path args[:file]
  TimeTracker::EntryImport.run file
end

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    require 'sequel'
    require_relative 'lib/time_tracker/db'
    Sequel.extension :migration
    db = Sequel.connect("sqlite://#{TimeTracker::DB.path}")
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrate", target: args[:version].to_i, use_transactions: true)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrate", use_transactions: true)
    end
  end
end

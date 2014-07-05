require 'yaml'

desc "Migrate yaml store to db"
task :entry_import, [:file] do |task, args|
  require_relative 'tasks/entry_import'
  file = File.expand_path args[:file]
  TimeTracker::EntryImport.run file
end

require 'sequel'
require_relative 'db'

module TimeTracker
  DB.connect
  class EntryLog < Sequel::Model
  end
end

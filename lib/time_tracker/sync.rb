require 'fileutils'
require 'typhoeus'
require 'json'

module TimeTracker
  class Sync

    attr_accessor :api_url, :headers

    def initialize(file = "#{ENV['HOME']}/.ttrc")
      FileUtils.touch file unless File.exists?(file)
      instance_eval File.read(file), file
    end

    def run(entries)
      entries.each do |e|
        sync_project(e)
        sync_task(e)
        sync_entry(e)
        sync_entry_log(e)
      end
    end

    def get(url, data = {})
      request(url, :get, data)
    end

    def post(url, data = {})
      request(url, :post, data)
    end

    def put(url, data = {})
      request(url, :put, data)
    end

    private

    def request(url, method, data)
      response = Typhoeus.send(method, url, data).
        response_body
      JSON.parse(response, symbolize_names: true)
    end
  end
end

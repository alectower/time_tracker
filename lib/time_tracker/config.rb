require 'fileutils'
require 'typhoeus'
require 'json'

module TimeTracker
  class Config
    def initialize(file = "#{ENV['HOME']}/.ttrc")
      FileUtils.touch file unless File.exists?(file)
      self.instance_eval File.read(file), file
    end

    def on_sync(&block)
      @on_sync = block
    end

    def sync(args)
      if @on_sync
        @on_sync.call args
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
      JSON.parse(response)
    end
  end
end

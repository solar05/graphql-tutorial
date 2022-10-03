module Rack
  class Middleware
    attr_reader :app

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      puts "O, HI MARK"
      app.call(env)
    end
  end
end

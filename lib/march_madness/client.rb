module MarchMadness
  class Client
    def initialize(config)
      @config = config
    end

    def post(request)
      call(:post, request)
    end

    def get(request)
      call(:get, request)
    end

    private

    def call(method, request)
      client.send(method, request)
    end

    def client
      Excon.new(@config.host, expects: [200])
    end
  end
end
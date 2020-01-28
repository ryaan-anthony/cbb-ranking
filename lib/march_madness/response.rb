module MarchMadness
  class Response
    delegate :[], to: :body

    def initialize(response)
      @response = response
    end

    def body
      @body ||= JSON.parse(@response.body)
    end
  end
end

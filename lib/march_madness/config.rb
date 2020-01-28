module MarchMadness
  class Config
    def initialize(filename, node)
      @filename = filename
      @node = node
    end

    def data
      @data ||= YAML.load(file_contents)[@node]
    end

    def method_missing(method, *args)
      data[method.to_s]
    end

    private

    def file_contents
      ERB.new(File.new(@filename).read).result
    end
  end
end
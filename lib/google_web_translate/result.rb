module GoogleWebTranslate
  class Result
    attr_reader :raw

    attr_reader :translation
    attr_reader :alternatives
    attr_reader :dictionary
    attr_reader :examples

    def initialize(data)
      @raw = data
      @keys = []
      @properties = {}

      extract_data(:translation, 0, 0, 0) # dt:t
      extract_data(:alternatives, 5, 0, 2) # dt:at
      extract_data(:dictionary, 1) # dt: bd
      extract_data(:synonyms, 11) # dt:ss
      extract_data(:definitions, 12, 0) # dt:md
      extract_data(:examples, 13, 0) # dt:ex
      extract_data(:see_also, 14, 0) # dt:rw

      @alternatives = @alternatives.collect { |i| i[0] } if @alternatives
      @keys.each { |key| @properties[key] = instance_variable_get("@#{key}") }
    end

    def to_h
      @properties
    end

    private

    def extract_data(name, *indices)
      value = array_value(@raw, *indices)
      return if value.nil?
      instance_variable_set("@#{name}", value)
      @keys.push(name)
    end

    def array_value(array, *indices)
      return nil if array.nil?
      index = indices.shift
      value = array[index]
      return value if indices.empty?
      array_value(value, *indices)
    end
  end
end

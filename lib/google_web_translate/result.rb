module GoogleWebTranslate
  # Translation results
  class Result
    attr_reader :raw

    # @private
    DATA_INDICES = {
      translation: [0, 0, 0], # dt:t
      alternatives: [5, 0, 2], # dt:at
      dictionary: [1], # dt: bd
      synonyms: [11], # dt:ss
      definitions: [12, 0], # dt:md
      examples: [13, 0], # dt:ex
      see_also: [14, 0], # dt:rw
    }.freeze

    DATA_INDICES.each_key { |key| attr_reader key }

    def initialize(data)
      @raw = data
      @keys = []
      @properties = {}

      DATA_INDICES.each do |key, indices|
        indices = indices.dup
        extract_data(key, *indices)
      end

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

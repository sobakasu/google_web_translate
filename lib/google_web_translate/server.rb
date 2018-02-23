module GoogleWebTranslate
  # @private
  SERVER_ATTRIBUTES = %i[host ip resolved_at last_used_at
                         counter available].freeze

  Server = Struct.new(*SERVER_ATTRIBUTES) do
    def to_json(*args)
      result = {}
      each_pair { |key, value| result[key] = value }
      result.to_json(args)
    end
  end
end

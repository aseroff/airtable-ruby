# frozen_string_literal: true

# Object corresponding to an Airtable Record
class Airtable::Record < Airtable::Resource
  attr_reader :fields

  def initialize(token, base_id, table_id, api_response)
    super(token)
    @base_id = base_id
    @table_id = table_id
    api_response.deep_symbolize_keys.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
  end
end

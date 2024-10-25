# frozen_string_literal: true

# Object corresponding to an Airtable Record
class Airtable::Record < Airtable::Resource
  def initialize(token, base_id, table_id, api_response)
    @token = token
    @base_id = base_id
    @table_id = table_id
    api_response.deep_symbolize_keys.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
    self.class.headers({ 'Authorization': "Bearer #{@token}", 'Content-Type': 'application/json' })
  end
end

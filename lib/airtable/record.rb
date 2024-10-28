# frozen_string_literal: true

# Object corresponding to an Airtable Record
class Airtable::Record < Airtable::Resource
  attr_reader :fields

  def initialize(token, base_id, table_id, id, api_response = nil)
    super(token)
    @base_id = base_id
    @table_id = table_id
    @id = id
    api_response&.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
  end

  # Instantiate record's table
  # @return [Airtable::Table]
  def table = Airtable::Table.new(token, @base_id, @table_id)

  # @return [Airtable::Record]
  # @see https://airtable.com/developers/web/api/update-record
  def update(record_data)
    response = self.class.patch(record_url,
                                body: { fields: record_data }.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Record.new @token, @base_id, @table_id, response['id'], response
  end

  protected

  # Endpoint for tables
  def record_url = "/v0/#{@base_id}/#{@table_id}/#{@id}"
end

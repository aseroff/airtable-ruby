# frozen_string_literal: true

# Object corresponding to an Airtable Record
class Airtable::Record < Airtable::Resource
  def initialize(token, base_id, table_id, id, data = nil)
    super(token)
    @base_id = base_id
    @table_id = table_id
    @id = id
    @data = data
  end

  # Return record data, retrieve if not present
  # @return [Hash]
  # @see https://airtable.com/developers/web/api/get-record
  def data
    @data ||= begin
      response = self.class.get(record_url).parsed_response

      check_and_raise_error(response)

      response
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

  # Endpoint for records
  def record_url = "/v0/#{@base_id}/#{@table_id}/#{@id}"
end

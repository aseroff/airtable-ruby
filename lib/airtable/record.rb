# frozen_string_literal: true

# Object corresponding to an Airtable Record
class Airtable::Record < Airtable::Resource
  attr_reader :table, :base

  def initialize(token, table, id, data = nil)
    super(token)
    @table = table
    @base = @table.base
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

  # @return [Airtable::Record]
  # @see https://airtable.com/developers/web/api/update-record
  def update(record_data)
    response = self.class.patch(record_url,
                                body: { fields: record_data }.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Record.new @token, @base.id, @table.id, response['id'], response
  end

  protected

  # Endpoint for records
  def record_url = "/v0/#{@base.id}/#{@table.id}/#{@id}"
end

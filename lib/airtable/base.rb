# frozen_string_literal: true

# Object corresponding to an Airtable Base
class Airtable::Base < Airtable::Resource
  def initialize(token, id)
    super(token)
    @id = id
  end

  # @param table_data [Hash] Payload for table creation. Expects {name:,description:,fields:[]}
  # @return [Airtable::Table]
  # @see https://airtable.com/developers/web/api/create-table
  def create_table(table_data)
    response = self.class.post("#{base_url}/tables",
                               body: table_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Table.new @token, @id, response
  end

  # @return [Array<Airtable::Table>]
  # @see https://airtable.com/developers/web/api/get-base-schema
  def tables
    response = self.class.get("#{base_url}/tables")

    check_and_raise_error(response)

    response['tables'].map { Airtable::Table.new(@token, @id, _1['id'], _1) }
  end

  # Instantiate table in base
  # @param table_id [String] ID of table
  # @return [Airtable::Table]
  def table(table_id)
    Airtable::Table.new(@token, @id, table_id)
  end

  protected

  # Endpoint for bases
  def base_url = "/v0/meta/bases/#{@id}"
end

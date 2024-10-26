# frozen_string_literal: true

# Object corresponding to an Airtable Base
class Airtable::Base < Airtable::Resource
  def initialize(token, id)
    @token = token
    @id = id
    self.class.headers({ 'Authorization': "Bearer #{@token}", 'Content-Type': 'application/json' })
  end

  # Expects {name:,description:,fields:[]}
  # @see https://airtable.com/developers/web/api/create-table
  # @return [Airtable::Table]
  def create_table(table_data)
    response = self.class.post("#{base_url}/tables",
                               body: table_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Table.new @token, @id, response
  end

  # @see https://airtable.com/developers/web/api/get-base-schema
  # @return [Array]<Airtable::Table>
  def tables
    response = self.class.get("#{base_url}/tables")

    check_and_raise_error(response)

    response['tables'].map { Airtable::Table.new(@token, @id, _1) }
  end

  # Instantiate table in base
  # @return [Airtable::Table]
  def table(table_id)
    Airtable::Table.new(@token, @id, table_id)
  end

  protected

  # Instantiate table in base
  def base_url = "/v0/meta/bases/#{@id}"
end

# frozen_string_literal: true

# Object corresponding to an Airtable Base
class Airtable::Base < Airtable::Resource
  def initialize(token, id)
    @token = token
    @id = id
    self.class.headers({ 'Authorization': "Bearer #{@token}", 'Content-Type': 'application/json' })
  end

  # Expects {name:,description:,fields:[]}
  def create_table(table_data)
    response = self.class.post("#{base_url}/tables",
                               body: table_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Table.new @token, @id, response
  end

  def tables
    response = self.class.get("#{base_url}/tables")

    check_and_raise_error(response)

    response['tables'].map { Airtable::Table.new(@token, @id, _1) }
  end

  protected

  def base_url = "/v0/meta/bases/#{@id}"
end

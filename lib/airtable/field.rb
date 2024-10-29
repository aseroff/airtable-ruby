# frozen_string_literal: true

# Object corresponding to an Airtable Field
class Airtable::Field < Airtable::Resource
  attr_reader :base, :table, :name, :type, :options

  def initialize(token, table, id, data = nil)
    super(token)
    @table = table
    @base = @table.base
    @id = id
    data&.each_key do |key|
      instance_variable_set(:"@#{key}", data[key])
    end
  end

  # @return [Airtable::Field]
  # @see https://airtable.com/developers/web/api/update-field
  def update(field_data)
    response = self.class.patch(field_url,
                                body: field_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Field.new(@token, @table, response)
  end

  protected

  # Endpoint for tables
  def field_url = "/v0/meta/bases/#{@base.id}/tables/#{@table.id}/fields/#{@id}"
end

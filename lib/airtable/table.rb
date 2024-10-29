# frozen_string_literal: true

# Object corresponding to an Airtable Table
class Airtable::Table < Airtable::Resource
  attr_reader :name, :base

  def initialize(token, base, id, data = nil)
    super(token)
    @base = base
    @id = id
    @data = data
  end

  # Return table model, retrieve if not present
  # @return [Hash]
  # @see https://airtable.com/developers/web/api/get-base-schema
  def data = @data ||= base.tables.find { _1.id == @id }.data

  # @return [Array<Airtable::Record>]
  # @see https://airtable.com/developers/web/api/list-records
  def records
    @records ||= begin
      response = self.class.get(table_url)

      check_and_raise_error(response)

      response['records'].map { Airtable::Record.new(@token, self, _1['id'], _1) }
    end
  end

  # Instantiate record in table
  # @param record_id [String] ID of record
  # @return [Airtable::Record]
  def record(record_id) = Airtable::Record.new(@token, @base.id, @id, record_id)

  # @return [Airtable::Table]
  # @see https://airtable.com/developers/web/api/update-table
  def update(table_data)
    response = self.class.patch("/v0/meta/bases/#{@base.id}/tables/#{@id}",
                                body: table_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Table.new @token, @base.id, response['id'], response
  end

  # @param [Array] Record objects to create
  # @return [Array<Airtable::Record>]
  # @see https://airtable.com/developers/web/api/create-records
  # @note API maximum of 10 records at a time
  def create_records(records)
    response = self.class.post(table_url,
                               body: { records: Array(records).map { |fields| { fields: } } }.to_json).parsed_response

    check_and_raise_error(response)

    response['records'].map { Airtable::Record.new(@token, @base.id, @id, _1['id'], _1) }
  end

  # @param [Array] IDs of records to delete
  # @return [Array] Deleted record ids
  # @see https://airtable.com/developers/web/api/delete-multiple-records
  # @note API maximum of 10 records at a time
  def delete_records(record_ids)
    params = Array(record_ids).compact.map { "records[]=#{_1}" }.join('&')
    response = self.class.delete("#{table_url}?#{params}").parsed_response

    check_and_raise_error(response)

    record_ids
  end

  # Deletes all table's records
  # @return [Integer] Number of deleted records
  def dump
    ids = records.map(&:id)
    ids.each_slice(10) do |record_id_set|
      delete_records(record_id_set)
      sleep(0.2)
    end
    ids.size
  end

  protected

  # Endpoint for tables
  def table_url = "/v0/#{@base.id}/#{@id}"
end

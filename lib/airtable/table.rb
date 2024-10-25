# frozen_string_literal: true

# Object corresponding to an Airtable Table
class Airtable::Table < Airtable::Resource
  def initialize(token, base_id, api_response)
    @token = token
    @base_id = base_id
    api_response.deep_symbolize_keys.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
    self.class.headers({ 'Authorization': "Bearer #{@token}", 'Content-Type': 'application/json' })
  end

  def records
    response = self.class.get(table_url)

    check_and_raise_error(response)

    response['records'].map { Airtable::Record.new(@token, @base_id, @table_id, _1) }
  end

  def update(table_data)
    response = self.class.patch("/v0/meta/bases/#{@base_id}/tables/#{@id}",
                                body: table_data.to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Table.new @token, @base_id, response
  end

  # limit 10 records
  def add_records(records)
    response = self.class.post(table_url,
                               body: { records: Array(records).map { |fields| { fields: } } }.to_json).parsed_response

    check_and_raise_error(response)

    response['records'].map { Airtable::Record.new(@token, @base_id, @id, _1) }
  end

  def delete_records(record_ids)
    params = Array(record_ids).compact.map { "records[]=#{_1}" }.join('&')
    response = self.class.delete("#{table_url}?#{params}").parsed_response

    check_and_raise_error(response)

    record_ids
  end

  def dump
    records.map(&:id).each_slice(10) do |record_id_set|
      delete_records(record_id_set)
      sleep(0.2)
    end
  end

  protected

  def table_url = "/v0/#{@base_id}/#{@id}"
end

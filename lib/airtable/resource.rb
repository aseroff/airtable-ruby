# frozen_string_literal: true

# Base class for authorized resources sending network requests
class Airtable::Resource
  include HTTParty
  base_uri 'https://api.airtable.com'
  # debug_output $stdout

  attr_reader :id, :token

  def initialize(token)
    @token = token
    self.class.headers({ 'Authorization': "Bearer #{@token}", 'Content-Type': 'application/json' })
  end

  # If API response is an error, raises an Airtable::Error with the error message
  def check_and_raise_error(response)
    response['error'] ? raise(Error, response['error']) : false
  end
end

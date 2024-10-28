# frozen_string_literal: true

# Object corresponding to an Airtable Workspace
class Airtable::Workspace < Airtable::Resource
  def initialize(token, id)
    super(token)
    @id = id
  end

  # @param base_data [Hash] Payload for base
  # @see https://airtable.com/developers/web/api/create-base
  def create_base(base_data)
    response = self.class.post('/v0/meta/bases',
                               body: base_data.merge({ workspaceId: @id }).to_json).parsed_response

    check_and_raise_error(response)

    Airtable::Base.new @token, response
  end
end

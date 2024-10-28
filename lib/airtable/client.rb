# frozen_string_literal: true

# Client carrying authorization token
class Airtable::Client < Airtable::Resource
  # @see https://airtable.com/developers/web/api/list-bases
  # @return [Array<Airtable::Base>]
  def bases
    response = self.class.get('/v0/meta/bases').parsed_response

    check_and_raise_error(response)

    response['bases'].map { Airtable::Base.new(@token, _1['id']) }
  end

  # Instantiate workspace
  # @return [Airtable::Workspace]
  def workspace(workspace_id)
    Airtable::Workspace.new(@token, workspace_id)
  end

  # Instantiate base
  # @return [Airtable::Base]
  def base(base_id)
    Airtable::Base.new(@token, base_id)
  end

  # @see https://airtable.com/developers/web/api/get-user-id-scopes
  # @return [Hash]
  def whoami
    response = self.class.get('/v0/meta/whoami').parsed_response

    check_and_raise_error(response)

    response
  end
end

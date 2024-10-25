# frozen_string_literal: true

# Client carrying authorization token
class Airtable::Client
  def initialize(token)
    @token = token
  end

  def base(base_id)
    Airtable::Base.new(@token, base_id)
  end
end

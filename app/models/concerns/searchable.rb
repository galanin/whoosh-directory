module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search_entry, as: :searchable
  end

end

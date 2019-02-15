class History < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId


  belongs_to :user_information

  scope :person,        -> { where(_type: 'HistoryPerson') }
  scope :search,        -> { where(_type: 'HistorySearch') }
  scope :unit,          -> { where(_type: 'HistoryUnit') }
  scope :created_today, -> { where(created_at: Time.now.beginning_of_day..Time.now.end_of_day) }
  scope :sort_updated,          -> { order(updated_at: :desc) }


  def as_json(options = nil)
    {
      "date" => updated_at,
      "date_formatted" =>  I18n.l(updated_at, format: I18n.t('history.output_format')),
      "data" => {
        "id" => short_id
      }
    }
  end

end


class HistoryPerson < History

  field :employment_short_id, type: String
  belongs_to :employment


  def as_json(options = nil)
    super.deep_merge(
      "data" =>  {
        "employment_short_id" => employment_short_id,
      }
    )
  end

end


class HistorySearch < History

  field :search_string, type: String

  def as_json(options = nil)
    super.deep_merge(
      "data" =>  {
        "search_string" => search_string,
      }
    )
  end


end


class HistoryUnit < History

  field :unit_short_id, type: String
  belongs_to :unit

  def as_json(options = nil)
    super.deep_merge(
      "data" =>  {
        "unit_id" => unit_short_id,
      }
    )
  end


end

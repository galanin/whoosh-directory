class SearchEntry < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :searchable, polymorphic: true

  field :unit_id,    type: String # unit_short_id
  field :person_id,  type: String # person_short_id
  field :employ_ids, type: Array # employment_short_ids
  field :keywords,   type: Array
  field :weights,    type: Hash # keyword weights

  index(keywords: 1)


  def self.query(query_str, limit = 10)
    query_arr = query_str.downcase.scan(/[\p{Word}]+/)
    pipeline = aggregation_pipeline(query_arr, limit)
    view = SearchEntry.collection.aggregate(pipeline)
    view_to_entries(view)
  end


  def as_json(options = nil)
    super.slice('unit_id', 'person_id', 'employ_ids').compact
  end


  private


  def self.aggregation_pipeline(query_arr, limit)
    weights_keys = query_arr.map { |query_term| "$weights.#{query_term}" }

    [
      {
        '$match' => {
          'keywords' => {
            '$all' => query_arr
          }
        },
      },
      {
        '$project' => {
          'unit_id'   => 1,
          'person_id' => 1,
          'employ_ids' => 1,
          'weight' => {
            '$sum' => weights_keys
          }
        }
      },
      {
        '$sort' => {
          'weight' => -1,
        }
      },
      {
        '$limit' => limit,
      },
    ]
  end


  def self.view_to_entries(view)
    view.map do |entry_doc|
      SearchEntry.new(entry_doc.except(:weight))
    end
  end

end

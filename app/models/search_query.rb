class SearchQuery < ApplicationRecord

  include FormattableBirthday

  def initialize(query_string)
    @query = query_string
  end


  def common?
    !birthday?
  end


  def birthday?
    birthday_scan.count >= 1
  end


  def type
    birthday? ? 'birthday' : 'common'
  end


  def birthday_interval
    birthdays_array = birthday_scan
    if birthdays_array.count == 1
      begin_date = search_date_to_db_format(birthdays_array.first.join)
      [begin_date, begin_date]
    else
      begin_date = search_date_to_db_format(birthdays_array.first.join)
      end_date = search_date_to_db_format(birthdays_array.second.join)
      [begin_date, end_date]
    end
  end


  def common
    @query
  end


  def birthday_scan
    @query.scan(I18n.t('birthday.search_regexp'))
  end


  def query_words
    raw_words.map{|query| normalize_query(query)}
  end

  def raw_words
    @query.downcase.scan(/[\p{Word}-]+/)
  end


  def phone_number?(query)
    query.gsub(/-|\(|\)/, '') =~ /^\d{4,}/
  end


  def normalize_query(query)
    if phone_number?(query)
      query.gsub(/-|\(|\)/, '')
    else
      query
    end
  end


  def execute(limit = 10)
    pipeline = aggregation_pipeline(query_words, limit)
    view = SearchEntry.collection.aggregate(pipeline)
    view_to_entries(view)
  end


  private


  def aggregation_pipeline(query_arr, limit)
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
          'contact_id' => 1,
          'weight' => {
            '$sum' => weights_keys
          },
          'sub_order' => 1,
        }
      },
      {
        '$sort' => {
          'weight' => -1,
          'sub_order' => 1,
        }
      },
      {
        '$limit' => limit,
      },
    ]
  end


  def view_to_entries(view)
    view.map do |entry_doc|
      SearchEntry.new(entry_doc.except(:weight))
    end
  end


end

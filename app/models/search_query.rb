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


  def birthday_period
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

end

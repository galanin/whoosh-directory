require 'date'

module FormattableBirthday
  extend ActiveSupport::Concern
  included do

    def birthday_formatted(birthday_string)
      format_with_year = "%Y-" + DB_BIRTHDAY_FORMAT
      I18n.l(Date.strptime("2004-" + birthday_string, format_with_year), format: I18n.t('birthday.interface_format'))
    end


    def search_date_to_db_format(date_string)
      Date.strptime(date_string, I18n.t('birthday.search_format')).strftime(DB_BIRTHDAY_FORMAT)
    end

  end

  DB_BIRTHDAY_FORMAT = '%m-%d'

end

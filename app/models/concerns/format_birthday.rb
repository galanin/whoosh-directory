module FormatBirthday
  extend ActiveSupport::Concern

  INPUT_BIRTHDAY_FORMAT = '%m-%d'

  def self.localize_birthday(birthday)
    I18n.l(Date.strptime(birthday, INPUT_BIRTHDAY_FORMAT), format: :birthday)
  end


  included do
    def birthday_formatted
      FormatBirthday.localize_birthday(birthday)
    end
  end

end

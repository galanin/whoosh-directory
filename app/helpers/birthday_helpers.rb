module BirthdayHelpers

  def get_birthday_entity(model, dates)
    model.where(destroyed_at: nil).in(birthday: dates).to_a
  end

end

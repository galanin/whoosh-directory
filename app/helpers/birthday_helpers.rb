module BirthdayHelpers

  def get_birthday_entity(model, begin_date, end_date)
    if end_date >= begin_date
      model.where({:birthday => {:$gte => begin_date, :$lte => end_date}}).to_a
    else
      result1 = model.where({:birthday => {:$gte => begin_date}}).to_a
      result2 = model.where({:birthday => {:$lte => end_date}}).to_a
      result1 + result2
    end
  end

end

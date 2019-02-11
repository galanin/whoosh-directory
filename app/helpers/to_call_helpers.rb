module ToCallHelpers

  def present_unchecked_and_checked_today(user_information_entity)
    present :unchecked, user_information_entity.to_call_unchecked_ids
    present :checked_today, user_information_entity.to_call_checked_today_ids
  end

end

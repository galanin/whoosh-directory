module ImportEntity

  def imported!
    @is_imported = true
  end


  def imported?
    @is_imported
  end


  def expired?
    ! @is_imported
  end

end

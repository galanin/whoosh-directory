class ToCall < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId

  field :checked_at, type: DateTime
  field :employment_short_id, type: String

  belongs_to :employment
  embedded_in :user_information

  scope :checked, -> { where(:checked_at.ne => nil).order(checked_at: :asc) }
  scope :unchecked, -> { where(:checked_at => nil).order(update_at: :desc) }


  def as_json(options = nil)
    result = super.slice(
      'checked_at',
    ).compact.merge(
      'id' => short_id,
      'employment_id' => employment_short_id,
    )
  end


  def checked?
    self.checked_at.present?
  end

  def check
    self.checked_at = DateTime.now
  end


  def uncheck
    self.checked_at = nil
  end

end

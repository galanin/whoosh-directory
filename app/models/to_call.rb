class ToCall < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId

  field :checked_at, type: DateTime
  field :employment_short_id, type: String
  field :contact_short_id, type: String

  belongs_to :to_whom, polymorphic: true
  belongs_to :user_information

  scope :checked, -> { where(:checked_at.ne => nil) }
  scope :checked_today, -> { where(checked_at: Time.now.beginning_of_day..Time.now.end_of_day) }
  scope :sort_checked, -> { order(checked_at: :desc) }
  scope :unchecked, -> { where(:checked_at => nil).order(updated_at: :asc) }
  scope :unchecked_and_checked_today, -> { any_of([unchecked.selector, checked_today.selector])}

  scope :history, ->(year, month, day) do
    if day.present?
      date = DateTime.new(year, month, day)
      checked.where(checked_at: date.beginning_of_day .. date.end_of_day).sort_checked
    else
      date = DateTime.new(year, month)
      checked.where(checked_at: date.beginning_of_month .. date.end_of_month).sort_checked
    end
  end

  index({employment_short_id: 1}, {} )
  index({checked_at: -1}, {} )


  def as_json(options = nil)
    json = {
      'checked_at' => checked_at,
      'id' => short_id,
    }
    json.merge!('employment_id' => employment_short_id) if employment_short_id.present?
    json.merge!('contact_id' => contact_short_id) if contact_short_id.present?
    json
  end


  def checked?
    self.checked_at.present?
  end


  def check
    self.checked_at ||= DateTime.now
  end


  def uncheck
    self.checked_at = nil
  end


  def check!
    check
    save if changed?
    self
  end


  def uncheck!
    uncheck
    save if changed?
    self
  end


  class << self

    def actual_employment(employment_short_id)
      unchecked_and_checked_today.where(employment_short_id: employment_short_id).first
    end


    def actual_contact(contact_short_id)
      unchecked_and_checked_today.where(contact_short_id: contact_short_id).first
    end


    def create_employment(employment_short_id)
      employment = Employment.find_by(short_id: employment_short_id)
      all.create!(to_whom: employment, employment_short_id: employment_short_id)
    end


    def create_contact(contact_short_id)
      contact = ExternalContact.find_by(short_id: contact_short_id)
      all.create!(to_whom: contact, contact_short_id: contact_short_id)
    end


    def add_employment(employment_short_id)
      employment_to_call = actual_employment(employment_short_id)
      if employment_to_call.present?
        employment_to_call.uncheck!
      else
        create_employment(employment_short_id)
      end
    end


    def add_contact(contact_short_id)
      contact_to_call = actual_contact(contact_short_id)
      if contact_to_call.present?
        contact_to_call.uncheck!
      else
        create_contact(contact_short_id)
      end
    end


    def check_employment(employment_short_id)
      employment_to_call = find_by(employment_short_id: employment_short_id)
      employment_to_call.check!
    end


    def check_contact(contact_short_id)
      contact_to_call = find_by(contact_short_id: contact_short_id)
      contact_to_call.check!
    end


    def destroy_employment(employment_short_id)
      where(employment_short_id: employment_short_id).destroy
    end


    def destroy_contact(contact_short_id)
      where(contact_short_id: contact_short_id).destroy
    end

  end

end

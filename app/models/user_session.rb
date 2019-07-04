require 'securerandom'

class UserSession < ApplicationRecord
  TOKEN_LENGTH = 20

  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :data, type: Hash

  cattr_reader :current, instance_reader: false

  belongs_to :user_information

  before_create do |session|
    session.token = SecureRandom.urlsafe_base64(TOKEN_LENGTH)
  end

  index({ token: 1 }, {})


  def self.find!(token)
    UserSession.find_by!(token: token)
  end


  def self.find(token)
    UserSession.where(token: token).first if token.present?
  end


  def self.find_or_create(token)
    find(token) || UserSession.create(user_information: UserInformation.create)
  end

end

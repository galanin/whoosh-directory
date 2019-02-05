task build_user_information: :environment do
  UserSession.all.each do |session|
    unless session.user_information.present?
      info = UserInformation.create(expanded_units: session.data[:expanded_units])
      session.user_information = info
      session.save
    end
  end
end

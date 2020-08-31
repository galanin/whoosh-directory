task build_user_information: :environment do
  UserSession.all.each do |session|
    unless session.user_information.present?
      info = UserInformation.create(expanded_units: session.data[:expanded_units])
      session.user_information = info
      session.save
    end
  end
end


task migrate_expanded: :environment do
  UserSession.all.each do |session|
    session.user_information.expanded_node_ids = session.user_information.expanded_units
    session.save
  end
end

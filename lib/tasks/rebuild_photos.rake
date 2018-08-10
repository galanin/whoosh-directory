task rebuild_photos: :environment do
  Person.all.each do |person|
    person.photo.recreate_versions! if person.photo.file
  end
end

require 'import/onpp'

task import: :environment do
  xml_str = IO.read File.join(Rails.root, 'tmp', 'onpp.xml')

  common_import = Import.new
  Import::ONPP.new(common_import, xml_str).execute

  common_import.save
  common_import.cleanup
end

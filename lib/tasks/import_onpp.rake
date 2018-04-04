require 'import/onpp'

task import: :environment do
  common_import = Import.new

  xml_str = IO.read File.join(Rails.root, 'tmp', 'onpp.xml')
  Import::ONPP.new(common_import, xml_str).execute

  common_import.save
  common_import.cleanup
end

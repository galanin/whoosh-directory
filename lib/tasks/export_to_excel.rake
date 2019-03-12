task :export_to_excel => :environment do
  Utilities::Exporter.to_excel
end

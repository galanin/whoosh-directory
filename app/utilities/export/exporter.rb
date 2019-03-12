require 'write_xlsx'

module Utilities
  class Exporter

    def self.to_excel
      workbook = WriteXLSX.new(ENV['STAFF_EXPORT_EXCEL_FILE_PATH'])
      worksheet = workbook.add_worksheet

      data = build_data
      headers = build_headers

      format = workbook.add_format
      format.set_align('left')
      worksheet.set_column(0, headers.count - 1, nil, format)
      set_column_width(worksheet)

      worksheet.add_table(
        0, 0, data.count-1, headers.count-1,
        :data    => data,
        :columns => headers,
      )
      workbook.close
    end


    private


    def self.set_column_width(worksheet)
      worksheet.set_column(0, 0, 15)
      worksheet.set_column(1, 1, 15)
      worksheet.set_column(2, 2, 15)
      worksheet.set_column(3, 3, 30)
      worksheet.set_column(4, 4, 20)
      worksheet.set_column(5, 5, 30)
      worksheet.set_column(6, 6, 15)
      worksheet.set_column(7, 7, 10)
      worksheet.set_column(8, 8, 10)
    end


    def self.build_headers
      [
        { :header => 'Фамилия', },
        { :header => 'Имя' },
        { :header => 'Отчество' },
        { :header => 'Должность' },
        { :header => 'Отдел' },
        { :header => 'Подразделение' },
        { :header => 'Телефон' },
        { :header => 'Корпус' },
        { :header => 'Комната' },
      ]
    end


    def self.build_data
      Person.where(destroyed_at: nil).map do |person|
        data = []
        employment = person.employments.first
        unit = employment.unit
        department = employment.department

        data << person.last_name
        data << person.first_name
        data << person.middle_name
        data << employment.post_title
        data << (department.present? ? department.short_title : nil)
        data << (unit == department ? nil : unit.short_title)
        data << get_phones(employment)
        data << employment.building
        data << employment.office

        data
      end
    end


    def self.get_phones(employment_entity)
      if employment_entity.telephones.present?
        phone_w_type = employment_entity.telephones.phone_w_type
        phone_array = []
        phone_w_type.each_value { |x| phone_array.concat(x) }
        phone_array.join(", ")
      end
    end


  end
end

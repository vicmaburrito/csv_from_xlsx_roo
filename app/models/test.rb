class Test < ApplicationRecord
    def self.import(file)
      xlsx = Roo::Excelx.new(file.tempfile)
      xlsx.each_row_streaming(offset: 1) do |row|
        new_format = self.new(
            telefono: row[0],
            tipo: row[1],
            numero_a: row[2],
            numero_b: row[3],
            fecha: row[4],
            hora: row[5],
            durac_seg: row[6], 
            latitude: row[7], 
            longitude: row[8]
        )
        next if self.pluck(:id).include?(new_format.id)
        new_format.save
      end
    end
  end
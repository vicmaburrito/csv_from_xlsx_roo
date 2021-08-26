class CreateTests < ActiveRecord::Migration[6.1]
  def change
    create_table :tests do |t|
      t.string :telefono
      t.string :tipo
      t.string :numero_a
      t.string :numero_b
      t.string :fecha
      t.string :hora
      t.string :durac_seg
      t.string :latitude
      t.string :longitude
      t.string :azimuth
      t.string :timestamp
      t.string :timestamp_value

      t.timestamps
    end
  end
end

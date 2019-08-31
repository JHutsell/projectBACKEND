class CreateApiV1Sessions < ActiveRecord::Migration[5.2]
  def change
    create_table :api_v1_sessions do |t|
      t.string :create

      t.timestamps
    end
  end
end

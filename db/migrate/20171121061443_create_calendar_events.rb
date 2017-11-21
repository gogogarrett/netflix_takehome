class CreateCalendarEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :calendar_events do |t|
      t.string :movie_id
      t.string :title
      t.integer :launch_date
      t.string :thumbnail_url

      t.timestamps
    end

    add_index :calendar_events, :movie_id, unique: true
  end
end

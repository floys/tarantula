class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string :value
      t.references :project

      t.timestamps
    end
    add_index :sentences, :project_id
  end
end

class CreateFoobars < ActiveRecord::Migration

  def up
    create_table :foobars do |t|
      t.string :name

      t.timestamps
    end

    10.times do |n|
      Foobar.create!(:name => "Entry number #{n}")
    end
  end
end

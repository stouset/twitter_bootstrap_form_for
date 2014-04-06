class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :password_confirmation
      t.string :twitter_id
      t.string :born_on
      t.string :interest_1
      t.string :interest_2
      t.string :interest_3
      t.string :newsletter
      t.string :weekly_newsletter
      t.string :monthly_newsletter
      t.string :agree
      t.string :spam
      t.string :spammer

      t.timestamps
    end
  end
end

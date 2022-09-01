class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :url
      t.text :description

      t.timestamps
    end

    Link.create url: 'http://graphql.org/', description: 'The Best Query Language'
    Link.create url: 'http://dev.apollodata.com/', description: 'Awesome GraphQL Client'
  end
end

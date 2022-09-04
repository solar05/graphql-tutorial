module Types
  class QueryType < Types::BaseObject
    field :all_links, resolver: Resolvers::LinksSearch

    field :link, Types::LinkType, null: false do
      argument :id, ID, required: true
    end
    
    def link(id:)
      Link.find(id)
    end
  end
end

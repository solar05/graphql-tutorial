
module Gql
  class QueryDepth < GraphQL::Analysis::AST::QueryDepth
    def result
      query_depth = super
      query.context.namespace(Gql::Metrics)[:query_depth] = query_depth
    end
  end
end

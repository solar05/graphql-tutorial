
module Gql
  class QueryComplexity < GraphQL::Analysis::AST::QueryComplexity
    def result
      complexity = super
      query.context.namespace(Gql::Metrics)[:query_complexity] = complexity
    end
  end
end

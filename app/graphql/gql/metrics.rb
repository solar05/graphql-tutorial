module Gql
  class Metrics
    Yabeda.configure do
      group :graphql

      histogram :request_duration,
                comment: "A histogram of query resolving time",
                unit: :seconds,
                tags: %i[
                  operation_status operation_name operation_type
                  operation_complexity operation_depth
                ],
                buckets: [0.001, *Prometheus::Client::Histogram::DEFAULT_BUCKETS, 15, 20, 25, 30].freeze

      counter :requests_total,
              comment: "Total number of GQL requests made",
              tags: %i[operation_status operation_name operation_type]
    end

    def self.use(schema)
      schema.query_analyzer(::Gql::QueryDepth)
      schema.query_analyzer(::Gql::QueryComplexity)

      schema.instrument(:query, ::Gql::MyInstrument.new)
    end
  end
end

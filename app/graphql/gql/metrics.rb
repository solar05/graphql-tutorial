module Gql
  class Metrics
    class Error < StandardError
    end

    REQUEST_BUCKETS = [
      0.001,
      0.005,
      0.01,
      0.025,
      0.05,
      0.1,
      0.25,
      0.5,
      1,
      2.5,
      5,
      10
    ].freeze

    Yabeda.configure do
      group :graphql

      histogram :request_duration_seconds,
                comment: "A histogram of query resolving time",
                unit: :seconds,
                tags: %i[
                  service operation_status operation_name operation_type
                  operation_complexity operation_depth metrics_collection_overhead
                ],
                buckets: Prometheus::Client::Histogram::DEFAULT_BUCKETS

      counter :requests_total,
              comment: "Total number of GQL requests made",
              tags: %i[service operation_status operation_name operation_type]
    end

    def self.use(schema)
      schema.query_analyzer(::Gql::QueryDepth)
      schema.query_analyzer(::Gql::QueryComplexity)

      schema.instrument(
        :query,
        ::Gql::MyInstrument.new(service_name: "a")
      )
    end
  end
end

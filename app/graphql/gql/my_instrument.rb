module Gql
  class MyInstrument
    attr_reader :service

    def initialize(service_name:)
      @service = service_name
    end

    def before_query(query)
      setup_time!(query)
    end

    def after_query(query)
      operation_status = query.valid? ? '[success]' : '[fail]'
      raw_operation_name = query.operation_name

      operation_name = if raw_operation_name
        extract_operation_name(raw_operation_name)
      else
        'unrecognizedOperation'
      end

      query_execution_time(query, operation_status, operation_name)
      query_result(operation_status, operation_name)
    end

    private

    def query_result(operation_status, operation_name)
      tags = {
        service: service,
        operation_status: operation_status,
        operation_name: operation_name
      }

      Yabeda.graphql.requests_total.increment(tags)
    end

    def query_execution_time(query, operation_status, operation_name)
      tags = {
        service: service,
        operation_status: operation_status,
        operation_name: operation_name
      }

      start = query.context.namespace(Gql::Metrics)[:start_time]
      lel = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
      elapsed = lel - start

      Yabeda.graphql.request_duration_seconds.measure(tags, elapsed)
    end

    def setup_time!(query)
      query.context.namespace(Gql::Metrics)[
        :start_time
      ] = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
    end

    def extract_operation_name(operation_name)
      operations = operation_name.split('__').compact.reject(&:empty?)
      operations.empty? ? "unrecognizedOperation" : operations.first
    end
  end
end

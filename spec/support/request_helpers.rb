module Requests
  module JsonHelpers
    def json
      JSON.parse(request.body)
    end

    def json_object_ids
      @json_object_ids ||= json['data'].map { |o| o['id'].to_i }
    end

    def record_type(record)
      record.class.to_s.split('::').last.pluralize.underscore
    end
  end
end

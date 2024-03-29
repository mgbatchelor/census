module Net
  class Service

    API_KEY = 'wfhkpuae2a47h8574efkwc9g'

    private

      def self.send_get(path, url_params)
        uri = create_uri(path, { api_key: API_KEY}.merge(url_params))
        Rails.logger.debug("GET #{uri.request_uri}")

        send_request(uri, Net::HTTP::Get.new(uri.request_uri))
      end

      def self.send_post(path, data={})
        uri = create_uri(path, url_params)
        Rails.logger.debug("POST #{uri.request_uri}")

        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = data.to_json
        Rails.logger.debug("DATA #{request.body}")
        send_request(uri, request)
      end

      def self.send_put(path, data={})
        uri = create_uri(path, url_params)
        Rails.logger.debug("PUT #{uri.request_uri}")

        request = Net::HTTP::Put.new(uri.request_uri)
        request.body = data.to_json
        Rails.logger.debug("DATA #{request.body}")
        send_request(uri, request)
      end

      def self.send_delete(path)
        uri = create_uri(path, url_params)
        Rails.logger.debug("DELETE #{uri.request_uri}")

        request = Net::HTTP::Delete.new(uri.request_uri)
        send_request(uri, request)
      end

      def self.create_uri(route, params)
        URI.parse("#{route}?#{params.to_query}")
      end

      def self.send_request(uri, request, retry_count=0)
        Rails.logger.error("RETRY #{retry_count}") if retry_count > 0

        http = Net::HTTP.new(uri.host, uri.port)
        if uri.port == 443
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        response = http.request(request)
        Rails.logger.debug("RESPONSE #{response}")
        begin
          JSON.parse(response.body).with_indifferent_access if response.body
        rescue JSON::ParserError
          sleep(1)
          Rails.logger.error("Could not parse response body.");
          send_request(uri, request, ++retry_count) if( retry_count < 3 )
        end
      end

  end
end

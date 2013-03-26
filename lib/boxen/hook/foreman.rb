require "boxen/hook"
require "json"
require "net/http"

module Boxen
  class Hook
    class Foreman < Hook
      def perform?
        enabled? && config.report?
      end

      private
      def call
        begin
          uri = URI.parse($foreman_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          if http.use_ssl?
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          req = Net::HTTP::Post.new("#{uri.path}/reports/create?format=yml")
          req.set_form_data({'report' => nil})
          response = http.request(req)
        rescue Exception => e
           warn "Could not send report to Foreman at #{ENV['BOXEN_FOREMAN_HOOK_URL']}/reports/create?format=yml: #{e}"
        end
      end

      def required_environment_variables
        ['BOXEN_FOREMAN_HOOK_URL']
      end
    end
  end
end

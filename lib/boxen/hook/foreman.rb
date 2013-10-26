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
        puts "Calling hook Foreman..."

        send_puppet_report
        send_facter_report
      end

      def send_puppet_report
        begin
          uri = URI.parse($foreman_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          if http.use_ssl?
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          Dir.glob("#{config.repodir}/log/reports/*.yaml").each do |filename|
            puppet_report = File.read(filename)

            req = Net::HTTP::Post.new("#{uri.path}/reports/create?format=yml")
            req.set_form_data({'report' => puppet_report})
            response = http.request(req)
          end
        rescue Exception => e
           warn "Could not send puppet report to Foreman at #{ENV['BOXEN_FOREMAN_HOOK_URL']}/reports/create?format=yml: #{e}"
        end
      end

      def send_facter_report
        begin
          uri = URI.parse($foreman_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          if http.use_ssl?
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          Dir.glob("#{config.repodir}/log/facts/*.yaml").each do |filename|
            facter_report = File.read(filename)

            req = Net::HTTP::Post.new("#{uri.path}/fact_values/create?format=yml")
            req.set_form_data({'facts' => facter_report})
            response = http.request(req)
          end
        rescue Exception => e
          warn "Could not send facts report to Foreman at #{ENV['BOXEN_FOREMAN_HOOK_URL']}/fact_values/create?format=yml: #{e}"
        end
      end

      def required_environment_variables
        ['BOXEN_FOREMAN_HOOK_URL']
      end
    end
  end
end

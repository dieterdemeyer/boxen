require "boxen/hook"
require "boxen/util"

module Boxen
  class Hook
    class PuppetReport < Hook
      def perform?
        enabled? && config.report?
      end

      private
      def call
        puts "Calling hook PuppetReport..."

        FileUtils.rm_rf "#{config.repodir}/log/reports"
        FileUtils.mkdir_p "#{config.repodir}/log/reports"

        Boxen::Util.sudo("/bin/cp", "#{config.puppetdir}/var/state/last_run_report.yaml", "#{config.repodir}/log/reports")
      end

      def required_environment_variables
        ['BOXEN_PUPPET_REPORTING_HOOK_ENABLED']
      end
    end
  end
end

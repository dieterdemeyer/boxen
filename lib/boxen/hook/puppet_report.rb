require "boxen/hook"

module Boxen
  class Hook
    class PuppetReport < Hook
      def perform?
        enabled? && config.report?
      end

      private
      def call
      end

      def required_environment_variables
        ['BOXEN_PUPPET_REPORTING_HOOK_ENABLED']
      end
    end
  end
end

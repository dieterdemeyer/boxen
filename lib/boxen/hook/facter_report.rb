require "boxen/hook"

module Boxen
  class Hook
    class FacterReport < Hook
      def perform?
        enabled? && config.report?
      end

      private
      def call
      end

      def required_environment_variables
        ['BOXEN_FACTER_REPORTING_HOOK_ENABLED']
      end
    end
  end
end

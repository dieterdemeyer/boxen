require "boxen/hook"

module Boxen
  class Hook
    class FacterReport < Hook
      def perform?
        enabled? && config.report?
      end

      private
      def call
        puts "Calling hook FacterReport..."

        FileUtils.mkdir_p "#{config.repodir}/log/facts"
        fqdn = `facter fqdn | tr '[A-Z]' '[a-z]'`.strip
        #File.open("#{config.repodir}/log/facts/#{fqdn}.yaml", 'w') { |file| file.write(`puppet facts find --render-as yaml #{fqdn}`) }
        File.open("#{config.repodir}/log/facts/#{fqdn}.yaml", 'w') { |file| file.write(Puppet::Node::Facts.new("#{fqdn}", Facter.to_hash).to_yaml) }
      end

      def required_environment_variables
        ['BOXEN_FACTER_REPORTING_HOOK_ENABLED']
      end
    end
  end
end

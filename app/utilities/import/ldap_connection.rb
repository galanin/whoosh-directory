require 'net/ldap'

module Utilities
  module Import
    class LdapConnection


      def initialize(host, base, user_name, user_password)
        @ldap = Net::LDAP.new(:host => host, :base => base)
        @ldap.authenticate(user_name, user_password)
      end


      def get_emails_as_hash(id_attr, mail_attr)
        results = @ldap.search(attributes: [id_attr, mail_attr])
        results.map { |entry| [entry.first(id_attr), entry.first(mail_attr)] }.to_h.compact
      end

    end
  end
end

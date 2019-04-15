require 'net/ldap'

module Utilities
  module Import
    class LdapConnection


      def initialize(host, base, user_name, user_password, id_ldap_attribute)
        @ldap = Net::LDAP.new(:host => host, :base => base)
        @ldap.authenticate(user_name, user_password)
        @id_ldap_attribute = id_ldap_attribute
      end


      def get_email(user_id)
        filter = Net::LDAP::Filter.eq(@id_ldap_attribute, user_id)
        result_attrs = ["mail"]
        results = @ldap.search(:filter => filter, :attributes => result_attrs)

        results.empty? || results[0][:mail].empty? ? (nil) : (results[0][:mail][0])
      rescue StandardError
        nil
      end

    end
  end
end

require 'jbundler'

class Configuration < Struct.new(:host, :port, :bind_dn, :password)

  def initialize(attributes = {})
    super(attributes[:host], attributes[:port].to_i, attributes[:bind_dn], attributes[:password])
  end
  
  def connect!
     com::unboundid::ldap::sdk::LDAPConnection.new(
      self.host, self.port, self.bind_dn, self.password) 
  end
end

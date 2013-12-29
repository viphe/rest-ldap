require 'jbundler'

class Configuration < Struct.new(:host, :port, :bind_dn, :password, :base_dn)
  include_package 'com.unboundid.ldap.sdk'

  def initialize(attributes = {})
    super(*attributes.values_at(*members))
    @mutex = Mutex.new
  end
  
  # Creates a new LDAPConnection and returns it. This will bypass any associated connection pool.
  def connect!
    com::unboundid::ldap::sdk::LDAPConnection.new(
      self.host, self.port, self.bind_dn, self.password) 
  end

  # Creates and returns a LDAPConnection using the internal pool. Release the retrieved connection with
  # #release.
  def connect
    @connection_pool.get_connection
  end

  def release(connection)
    @connection_pool.release_connection(connection)
  end

  def connect_pool!
    @mutex.lock do
      close
      connection = connect!
      @connection_pool = com::unboundid::ldap::sdk::LDAPConnectionPool.new(connection, 1, 5)
    end
  end

  def ensure_pool
    @mutex.lock do
      if @connection_pool.nil?
        connect_pool?
      end
    end

    @connection_pool
  end

  # Closes the connection pool associated with this Configuration if there is one.
  def close
    @mutex.lock do
      unless @connection_pool.nil? or @connection_pool.is_closed
        @connection_pool.close
        @connection_pool = nil
      end
    end
  end

  def with_connection(&block)
    pool = ensure_pool
    begin
      connection = pool.get_connection()
      yield connection
    ensure
      pool.release_connection(connection)
    end
  end

  def search_users(options = {})
    configuration.with_connection do |connection|
      search_results = connection.search(configuration.base_dn, SearchScope::SUB, '(objectClass=*)')
      search_result.search_entries.map { |entry| entry.get_attribute_value('mail') }
    end
  end
end

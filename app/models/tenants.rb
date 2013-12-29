require 'singleton'
require 'jbundler'

class Tenants
  include Singleton
  include_package 'com.google.common.cache'
  java_import java.util.concurrent.TimeUnit

  def initialize
    @cache = CacheBuilder.new_builder
      .cache_size(100)
      .expire_after_access(1, TimeUnit::DAYS)
      .removal_listener { |notification| on_tenant_removal(notification.value) }
      .build
  end

  def get_or_create_tenant(owner, name, configuration = nil)
    cache_key = Tenant.cache_key(owner, name)
    tenant = @cache.get(cache_key)
    if tenant
      unless configuration.nil?
        @cache.configuration = configuration
      end
      tenant
    elsif configuration.nil?
      tenant = Tenant.new(owner: owner, name: name, configuration: configuration)
      @cache.put(cache_key, tenant)
      tenant
    else
      nil
    end
  end

  def on_tenant_removal(tenant)
    tenant.close
  end

end


class Tenant < Struct.new(:owner, :name, :configuration)

  def initialize(attributes = {})
    super *attributes.values_at(*members)
    touch
  end
  
  def configuration=(new_config)
    old_config = self.configuration
    super new_config
    unless old_config.nil?
      old_config.close
    end
    new_config
  end

  def cache_key
    self.class.cache_key(self.owner, self.name)
  end

  def self.cache_key(owner, name)
    "#{owner}/#{name}"
  end

  def close
    config = self.configuration
    config.close unless config.nil?
  end

end

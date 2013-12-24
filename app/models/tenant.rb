
class Tenant < Struct.new(:id, :owner, :name, :configuration, :last_access)

	def initialize(attributes = {})
		super *attributes.values_at(*members)
		touch
	end

	def touch
		last_access ||= DateTime.now
	end
end

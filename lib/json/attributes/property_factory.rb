module Json
  module Attributes

    class PropertyFactory
      attr_accessor :name
      attr_accessor :type
      attr_accessor :required
      attr_accessor :default
  
      def initialize(opts)
        opts.requires_keys_are_not_nil(:name, :type)
        opts[:required] = false unless opts.key?(:required)
        opts[:default]  = false unless opts.key?(:default)

        @name     = opts[:name]
        @type     = opts[:type]
        @required = opts[:required]
        @default  = opts[:default]
      end
  
      def to_java
        raise "Not implemented"
      end
  
    end

  end
end

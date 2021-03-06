require 'active_support/inflections'
require 'active_support/inflector/methods'
require 'uri'

module Json
  module Attributes

    class PropertyFactory
      attr_accessor :name
      attr_accessor :type
      attr_accessor :required
      attr_accessor :default_value
      
      def self.create_from_properties(properties)
        properties.collect{ |key, property| create_from_property(key, property) }
      end
      
      
      def self.create_from_property(key, property)
        ## Example:
        # "first": {
        #   "type":"string",
        #   "id": "http://jsonschema.net/first",
        #   "default": "Rae",
        #   "required":false
        # },
        
        property.symbolize_keys_recursively!
        property.requires_keys_are_not_nil(:type, :id, :required)
        property.requires_keys_are_present(:default)
        
        self.new(property.merge(name: key))
      end
        
  
      def initialize(opts)
        opts.requires_keys_are_not_nil(:name, :type)

        @name            = ActiveSupport::Inflector.camelize(opts[:name], true)
        @name_underscore = ActiveSupport::Inflector.underscore(name)
        @name_camelize   = ActiveSupport::Inflector.camelize(name, true)

        @type            = Json::TypeMapper.parse(opts)
        @required        = opts[:required]
        @default_value   = opts[:default]
      end
  
      def to_java
        [
          member_variable,
          default,
          getter,
          setter
        ].join("\n")
      end
      
      def member_variable
        options = []
        
        # TODO: There are A LOT of attributes we can use here. For now let's keep this simple
        options << 'index = true'      if @required
        options << 'canBeNull = false' if @required

        options.sort! # For ease of use, always sort these
        options_str = ''
        options_str = "(#{options.join(', ')})" unless options.empty?
        
        "@DatabaseField#{options_str} private #{@type} #{@name_underscore} = null;"
      end
      
      def build_method_signature(prefix, postfix, arguments = [], body)
        "public final #{@type} #{prefix}#{@name_camelize}#{postfix}(#{arguments.join(', ')}) { #{body} }"
      end
      
      def getter
        "public final #{@type} get#{@name_camelize}() { return null != this.#{@name_underscore} ? this.#{@name_underscore} : get#{@name_camelize}Default(); }"
      end
      
      def setter
        "public final #{@type} set#{@name_camelize}(#{@type} _#{@name_underscore}) { return this.#{@name_underscore} = _#{@name_underscore}; }"
      end
      
      def default
        return "public final #{@type} get#{@name_camelize}Default() { return null; }" if @default_value.nil?

        case @type
        when 'String'
          "public final #{@type} get#{@name_camelize}Default() { return \"#{@default_value}\"; }"
        else
          "public final #{@type} get#{@name_camelize}Default() { return #{@default_value}; }"
        end
      end
    end

  end
end

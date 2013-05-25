require 'active_support/inflections'
require 'active_support/inflector/methods'

module Json
  module Attributes

    class PropertyFactory
      attr_accessor :name
      attr_accessor :type
      attr_accessor :required
      attr_accessor :default
  
      def initialize(opts)
        opts.requires_keys_are_not_nil(:name, :type)

        @name            = ActiveSupport::Inflector.camelize(opts[:name], true)
        @name_underscore = ActiveSupport::Inflector.underscore(name)
        @name_camelize   = ActiveSupport::Inflector.camelize(name, true)

        @type            = Json::TypeMapper.map(opts[:type])
        @required        = opts[:required]
        @default         = opts[:default]
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
        "private #{@type} #{@name_underscore} = null;"
      end
      
      def getter
        "public final #{@type} get#{@name_camelize}() { return null != this.#{@name_underscore} ? this.#{@name_underscore} : get#{@name_camelize}Default(); }"
      end
      
      def setter
        "public final #{@type} set#{@name_camelize}(#{@type} _#{@name_underscore}) { return this.#{@name_underscore} = _#{@name_underscore}; }"
      end
      
      def default
        return "public final #{@type} get#{@name_camelize}Default() { return null; }" if @default.nil?

        case @type
        when 'String'
          "public final #{@type} get#{@name_camelize}Default() { return \"#{@default}\"; }"
        else
          "public final #{@type} get#{@name_camelize}Default() { return #{@default}; }"
        end
      end
    end

  end
end

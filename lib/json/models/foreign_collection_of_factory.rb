require 'active_support/inflections'
require 'active_support/inflector/methods'
require 'uri'

###
# What is a ForeignCollection anyway? (http://stackoverflow.com/a/15877309)
# 
# A "ForeignCollection" is a Parent-Child relationship using JOIN tables.
# We store the relationship in a seperate table to allow the Child class to be re-used throughout the system.
###
# 
# // I am the REUSABLE "Foo" object
# // I am used by many classes througout the system.
# @DatabaseTable public class Foo {
#     @DatabaseField(id = true) private int id;
#     
#     // ...
# }
# 
# 
# // I have a reference to a list of "Foo" objects via "Foos"
# @DatabaseTable public class Bar {
#     @DatabaseField(id = true) private int id;
#     
#     @DatabaseField(foreign=true, columnName="foos_id")
#     private Foos foos;
# }
# 
# 
# // I contain a list of "Foo" objects
# @DatabaseTable public class Foos {
#     @DatabaseField(id = true) private int id;
#     
#     // What "Bar" object do I belong to?
#     @DatabaseField(foreign=true)
#     private Bar bar;
#     
#     // What "Foo" objects do I contain?
#     @ForeignCollectionField(eager = false)
#     private Collection<Foo> result;
# }

module Json
  module Models

    class ForeignCollectionOfFactory
      attr_accessor :parent_type
      attr_accessor :child_type
      attr_accessor :collection_type
      
      # <parent>ForeignCollectionOf<child>
      def initialize(opts)
        opts.requires_keys_are_not_nil(:parent_type, :child_type)
        
        @parent_type       = ActiveSupport::Inflector.camelize(opts[:parent_type], true)
        @parent_underscore = ActiveSupport::Inflector.underscore(opts[:parent_type])

        @child_type        = ActiveSupport::Inflector.camelize(opts[:child_type], true)
        @child_underscore  = ActiveSupport::Inflector.underscore(opts[:child_type])
        
        @collection_type   = "#{parent_type}ForeignCollectionOf#{ActiveSupport::Inflector.pluralize(child_type)}"
      end
      
      def to_file_name
        "#{collection_type}.java"
      end
      
      def to_java
        lines = []
        lines << "@DatabaseTable public final class #{@collection_type} {"
        lines << "\t@DatabaseField(generatedId = true) private Integer id;"
        lines << ""
        lines << "\t#{parent_member_variable}"
        lines << "\t#{child_member_variable}"
        lines << ""
        lines << "\t#{parent_getter}"
        lines << "\t#{parent_setter}"
        lines << ""
        lines << "\t#{child_getter}"
        lines << "\t#{child_setter}"
        lines << ""
        lines << "}"
        lines << ""
        lines.join("\n")
      end
      
      def parent_member_variable
        "@DatabaseField(foreign=true) private #{parent_type} #{@parent_underscore};"
      end
      
      def parent_getter
        "public final #{parent_type} get#{parent_type}() { return this.#{@parent_underscore}; }"
      end
      
      def parent_setter
        "public final #{parent_type} set#{parent_type}(#{parent_type} _#{@parent_underscore}) { return this.#{@parent_underscore} = _#{@parent_underscore}; }"
      end

      
      def child_member_variable
        "@ForeignCollectionField(eager = false) private ForeignCollection<#{child_type}> #{ActiveSupport::Inflector.pluralize(@child_underscore)};"
      end
      
      def child_getter
        "public final ForeignCollection<#{child_type}> get#{ActiveSupport::Inflector.pluralize(child_type)}() { return this.#{@child_underscore}; }"
      end
      
      def child_setter
        "public final ForeignCollection<#{child_type}> set#{ActiveSupport::Inflector.pluralize(child_type)}(ForeignCollection<#{child_type}> _#{@child_underscore}) { return this.#{@child_underscore} = _#{@child_underscore}; }"
      end
      
      
      
    end

  end
end
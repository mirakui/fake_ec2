module FakeEc2
  class XmlBuilder
    def build_root(hash, options={})
      root, hash = hash.first
      out = ''
      out += %Q(<?xml version="1.0" encoding="UTF-8"?>\n)
      out += "<#{camelize root}"
      out += %Q( xmlns="#{options[:xmlns]}") if options[:xmlns]
      out += ">\n"
      out += "#{indent(build(hash))}\n"
      out += "</#{camelize root}>\n"
      out.chomp
    end

    def build(hash)
      out = ''
      hash.each do |tag, child|
        if tag.is_a?(Hash)
          tag, child = tag.first
        end
        tag = camelize tag
        case child
        when nil
          out += "<#{tag}/>\n"
        when Array, Hash
          out += "<#{tag}>\n#{indent build(child)}\n</#{tag}>\n"
        else
          out += "<#{tag}>#{child}</#{tag}>\n"
        end
      end
      out.chomp
    end

    class << self
      def build(hash)
        new.build hash
      end
    end

    private
      def indent(str, size=4)
        spaces = ' ' * size
        str.to_s.gsub(/^/, spaces)
      end

      def camelize(str)
        str.to_s.gsub(/_([a-z])/) { $1.upcase }
      end
  end
end

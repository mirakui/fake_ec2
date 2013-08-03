module FakeEc2
  class RequestParser
    class << self
      def parse(query_string)
        result = {}
        query_string = query_string.sub(/^\?/, '')
        query_string.split('&').each do |pair|
          key, value = pair.split('=')
          parse_key_and_set_value(result, key, value)
        end
        deep_compact!(result)
        result
      end

      private
        def parse_key_and_set_value(hash, key, value)
          tokens = key.split('.')
          tokens[0..-2].each_with_index do |token, i|
            token = token =~ /^\d+$/ ? token.to_i : underscore(token).to_sym
            if tokens[i+1] =~ /^\d+$/
              hash[token] ||= []
            else
              hash[token] ||= {}
            end
            hash = hash[token]
          end
          last_index = tokens.last =~ /^\d+/ ?
            tokens.last.to_i :
            underscore(tokens.last).to_sym
          hash[last_index] = value
          hash
        end

        def underscore(str)
          str.gsub!(/(.)([A-Z])/) { "#{$1}_#{$2.downcase}" }
          str.gsub!(/^([A-Z])/) { "#{$1.downcase}" }
          str
        end

        def deep_compact!(hash_or_array)
          case hash_or_array
          when Array
            hash_or_array.compact!
            hash_or_array.each {|obj| deep_compact!(obj) }
          when Hash
            hash_or_array.each {|key, obj| deep_compact!(obj) }
          end
        end
    end
  end
end

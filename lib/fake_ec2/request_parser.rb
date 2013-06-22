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
          hash[underscore(tokens.last).to_sym] = value
          hash
        end

        def underscore(str)
          str.gsub!(/(.)([A-Z])/) { "#{$1}_#{$2.downcase}" }
          str.gsub!(/^([A-Z])/) { "#{$1.downcase}" }
          str
        end
    end
  end
end

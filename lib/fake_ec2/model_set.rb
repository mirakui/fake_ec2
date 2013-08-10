module FakeEc2
  class ModelSet < Array
    def initialize(items=[])
      self.replace(items) if items
    end

    def itemize
      map do |item|
        { item: item.respond_to?(:itemize) ? item.itemize : item }
      end
    end

    def filter(&block)
      result = self.class.new
      each do |item|
        result << item if item.instance_eval(&block)
      end
      result
    end
  end
end

module TTYHue
  class Parser
    class ColorStack

      def initialize
        @stack = []
      end

      def push(value, opts={})
        @stack.unshift({value: value, opts: opts})
      end

      def pop(value, opts={})
        @stack.each_with_index do |v,i|
          if v[:value] == value && v[:opts] == opts
            @stack.delete_at(i)
            break
          end
        end
      end

      def top(opts={})
        @stack.select do |e|
          e[:opts] == opts
        end.first.to_h[:value]
      end

    end
  end
end

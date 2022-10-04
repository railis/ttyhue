module TTYHue
  class Parser
    class Tag

      def initialize(str)
        @str = str
        @match_data = str.match(regexp)
        return unless @match_data
      end

      def valid?
        !!@match_data
      end

      def closing
        @match_data[:closing] != ""
      end

    end
  end
end

require_relative "color_tag"
require_relative "style_tag"

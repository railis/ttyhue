module TTYHue
  class Parser
    class ColorTag < Tag

      def regexp
        /{(?<closing>\/?)(?<bg>b?)(?<name>#{TermColor.defs.map(&:tag_name).join("|")})}/
      end

      attr_reader :color_name, :bg

      def bg
        @match_data[:bg] != ""
      end

      def closing
        @match_data[:closing] != ""
      end

      def color_name
        TermColor.by_tag(@match_data[:name]).color_name
      end

    end
  end
end

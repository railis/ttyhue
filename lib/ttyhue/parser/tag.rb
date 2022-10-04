module TTYHue
  class Parser
    class Tag

      def self.regexp
        /{(?<closing>\/?)(?<bg>b?)(?<name>#{TermColor.defs.map(&:tag_name).join("|")})}/
      end

      def self.valid?(str)
        !!str.match(regexp)
      end

      attr_reader :color_name, :closing, :bg

      def initialize(str)
        match_data = str.match(self.class.regexp)
        tag_name = match_data[:name]
        @bg = match_data[:bg] != ""
        @closing = match_data[:closing] != ""
        @color_name = TermColor.by_tag(tag_name).color_name
      end

    end
  end
end

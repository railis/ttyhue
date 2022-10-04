module TTYHue
  class Parser
    class StyleTag < Tag

      def regexp
        /{(?<closing>\/?)(?<name>#{@styles.keys.map(&:to_s).join("|")})}/
      end

      def initialize(str, styles = {})
        @styles = styles
        super(str)
      end

      def fg_color_name
        TermColor.by_tag(styles_hash[:fg].to_s)&.color_name
      end

      def bg_color_name
        TermColor.by_tag(styles_hash[:bg].to_s)&.color_name
      end

      private

      def styles_hash
        @styles[@match_data[:name].to_sym]
      end

    end
  end
end

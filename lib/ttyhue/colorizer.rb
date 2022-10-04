module TTYHue
  class Colorizer

    class << self

      def colorize(str)
        Parser.new(str).parse.map do |parsed_section|
          colorized_section(parsed_section)
        end.join
      end

      private

      def colorized_section(section)
        "".tap do |str|
          if section[:bg] == :default && section[:fg] == :default
            str << section[:str]
          else
            str << closing_byte
            str << opening_csi_for_color(section[:fg], false) if section[:fg] != :default
            str << opening_csi_for_color(section[:bg], true) if section[:bg] != :default
            str << section[:str]
            str << closing_byte
          end
        end
      end

      def opening_csi_for_color(color, bg)
        "\x1b[#{TermColor.by_name(color).term_hex(bg)}m"
      end

      def closing_byte
        "\033[m"
      end

    end

  end
end

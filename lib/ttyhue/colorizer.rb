module TTYHue
  class Colorizer

    class << self

      def colorize(str)
        Parser.new(str).parse.map do |parsed_section|
          colorize_section(parsed_section)
        end.join
      end

      private

      def colorize_section(section)
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
        "\x1b[#{hex_params_for_color(color, bg)}m"
      end

      def closing_byte
        "\033[m"
      end

      def hex_params_for_color(color, bg)
        case color
        when Integer
          prefix = bg ? "48;5;" : "38;5;"
          prefix + color.to_s
        else
          color_digit = digit_for_termcolor[color.to_s.gsub("light_", "").to_sym]
          if color.to_s.start_with?("light_")
            bg ? "10#{color_digit}" : "9#{color_digit}"
          else
            bg ? "4#{color_digit}" : "3#{color_digit}"
          end
        end
      end

      def digit_for_termcolor
        {
          black: 0,
          red: 1,
          green: 2,
          yellow: 3,
          blue: 4,
          magenta: 5,
          cyan: 6,
          white: 7
        }
      end

    end

  end
end

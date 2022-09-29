module TTYHue
  class Tokenizer

    class << self

      def tokens
        {
          bg_open_tag: { class: :bg_open_tag, pattern: /\{/ },
          bg_close_tag: { class: :bg_close_tag, pattern: /\{\// },
          end_tag: { class: :end_tag, pattern: /\}/ },
          colors: [].tap do |res|
            [false, true].each do |bg|
              [false, true].each do |lightness_modifier|
                %w[black red green yellow blue magenta cyan white].each do |color_class|
                  res << color_token(color_class: color_class, bg: bg, lightness_modifier: lightness_modifier)
                end
              end
              res << color_token(color_class: 'number', bg: bg)
            end
          end,
          content: { class: :content, pattern: /[^{]+/ }
        }
      end

      private

      def color_token(color_class: nil, bg: nil, lightness_modifier: nil, color_number: nil)
        {
          class: :color,
          color_class: [('light' if lightness_modifier), color_class].compact.join("_").to_sym,
          bg: bg,
          pattern: color_pattern(color_class: color_class, bg: bg, lightness_modifier: lightness_modifier)
        }
      end

      def color_pattern(color_class:, bg:, lightness_modifier:)
        bg_part = bg ? "b" : ''
        case color_class
        when "number"
          /#{bg_part}c\d{1,3}/
        else
          /#{bg_part}#{'l' if lightness_modifier}#{color_class}/
        end
      end

    end

  end
end

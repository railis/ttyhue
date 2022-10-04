require 'strscan'
require_relative "parser/tag"
require_relative "parser/color_stack"

module TTYHue
  class Parser

    TOKENS = {
      tag: /{[^{}]+}/,
      content: /[^{]+/
    }

    class ParseError < StandardError; end

    def initialize(string, styles = {})
      @string = string
      @styles = TTYHue.global_style.merge(styles)
    end

    def parse
      @color_stack = ColorStack.new
      @result = []
      scanner = StringScanner.new(@string)
      until scanner.eos?
        next if handle_content!(scanner.scan(TOKENS[:content]))
        next if handle_tag!(scanner.scan(TOKENS[:tag]))
      end
      flattened_result
    end

    private

    def flattened_result
      [].tap do |res|
        @result.each do |e|
          last = res.last
          if last && last[:fg] == e[:fg] && last[:bg] == e[:bg]
            last[:str] += e[:str]
          else
            res << e
          end
        end
      end
    end

    def handle_content!(str)
      return false unless str

      @result << {
        fg: @color_stack.top(bg: false) || :default,
        bg: @color_stack.top(bg: true) || :default,
        str: str
      }
    end

    def handle_tag!(str)
      return false unless str

      color_tag = ColorTag.new(str)
      style_tag = StyleTag.new(str, @styles)

      if color_tag.valid?
        if color_tag.closing
          @color_stack.pop(color_tag.color_name, bg: color_tag.bg)
        else
          @color_stack.push(color_tag.color_name, bg: color_tag.bg)
        end
      elsif style_tag.valid?
        if style_tag.closing
          @color_stack.pop(style_tag.fg_color_name, bg: false) if style_tag.fg_color_name
          @color_stack.pop(style_tag.bg_color_name, bg: true) if style_tag.bg_color_name
        else
          @color_stack.push(style_tag.fg_color_name, bg: false) if style_tag.fg_color_name
          @color_stack.push(style_tag.bg_color_name, bg: true) if style_tag.bg_color_name
        end
      else
        handle_content!(str)
      end
    end

  end
end

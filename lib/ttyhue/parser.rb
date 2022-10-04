require 'strscan'
require_relative "parser/tag"
require_relative "parser/color_stack"

module TTYHue
  class Parser

    class Tag

    end

    TOKENS = {
      tag: /{[^{}]+}/,
      content: /[^{]+/
    }

    class ParseError < StandardError; end

    def initialize(string)
      @string = string
    end

    def parse
      @color_stack = ColorStack.new
      @result = []
      scanner = StringScanner.new(@string)
      until scanner.eos?
        next if handle_content!(scanner.scan(TOKENS[:content]))
        next if handle_tag!(scanner.scan(TOKENS[:tag]))
      end
      @result
    end

    private

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

      if Tag.valid?(str)
        tag = Tag.new(str)
        if tag.closing
          @color_stack.pop(tag.color_name, bg: tag.bg)
        else
          @color_stack.push(tag.color_name, bg: tag.bg)
        end
      else
        handle_content!(str)
      end
    end

  end
end

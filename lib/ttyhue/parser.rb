require 'strscan'

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

    TOKENS = {
      tag: /{[^{}]+}/,
      content: /[^{]+/
    }

    class ParseError < StandardError; end

    def initialize(string)
      @string = string
      @bg_color_stack = []
      @fg_color_stack = []
    end

    def parse
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
        fg: @fg_color_stack.first || :default,
        bg: @bg_color_stack.first || :default,
        str: str
      }
    end

    def handle_tag!(str)
      return false unless str

      if Tag.valid?(str)
        tag = Tag.new(str)
        if tag.closing
          color_stack(tag.bg).shift
        else
          color_stack(tag.bg).unshift(tag.color_name)
        end
      else
        handle_content!(str)
      end
    end

    def color_stack(bg)
      bg ? @bg_color_stack : @fg_color_stack
    end

  end
end

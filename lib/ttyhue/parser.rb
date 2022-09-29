require 'strscan'
require_relative 'tokenizer'

module TTYHue
  class Parser

    class ParseError < StandardError; end

    def initialize(string)
      @string = string
      @tokens = Tokenizer.tokens
    end

    def parse
      reset_helper_variables!
      until @scanner.eos?
        case @state
        when :default
          look_ahead_for_tokens(@tokens[:content], @tokens[:bg_close_tag], @tokens[:bg_open_tag])
        when :opened_tag
          look_ahead_for_tokens(*@tokens[:colors])
          handle_unfinished_tag_state :opened_tag do |unexpected_string|
            "Unexpected string '#{unexpected_string}' after `{`. Expecting color value."
          end
        when :passed_color
          look_ahead_for_tokens(@tokens[:end_tag])
          handle_unfinished_tag_state :passed_color do |unexpected_string|
            "Unexpected string '#{unexpected_string}' after color:#{@all_color_stack.first}. Expecting '}'."
          end
        when :opened_close_tag
          look_ahead_for_tokens(*@tokens[:colors])
          handle_unfinished_tag_state :opened_close_tag do |unexpected_string|
            "Unexpected string '#{unexpected_string}' after `{/`. Expecting color:#{@all_color_stack.first}."
          end
        end
      end
      @result
    end

    private

    def handle_unfinished_tag_state(state, &block)
      return unless @state == state

      pointer = @scanner.pos.dup
      unexpected_string = anything_until(:end_tag)
      msg = block.call(unexpected_string)
      raise_error msg, pointer
    end

    def look_ahead_for_tokens(*tokens)
      tokens.each do |token|
        if str = @scanner.scan(token[:pattern])
          handle_token(token, str)
        end
      end
    end

    def handle_token(token, str)
      case token[:class]
      when :bg_open_tag
        @state = :opened_tag
      when :bg_close_tag
        @state = :opened_close_tag
        @closing_tag = true
      when :end_tag
        @state = :default
      when :color
        @state = :passed_color
        color_value = token[:color_class] == :number ? str.scan(/\d{1,3}/).first.to_i : token[:color_class]
        if @closing_tag
          stack = token[:bg] ? @color_bg_stack : @color_class_stack
          if stack.first == color_value
            stack.shift
            @all_color_stack.shift
          else
            raise_error "Unexpected color:#{color_value} tag closing. Expected color:#{stack.first}", @scanner.pos
          end
          @closing_tag = false
        else
          (token[:bg] ? @color_bg_stack : @color_class_stack).unshift(color_value)
          @all_color_stack.unshift(color_value)
        end
      when :content
        @result << { fg: @color_class_stack.first || :default, bg: @color_bg_stack.first || :default, str: str }
      end
    end

    def reset_helper_variables!
      @state = :default
      @closing_tag = false
      @color_class_stack = []
      @color_bg_stack = []
      @all_color_stack = []
      @scanner = StringScanner.new(@string)
      @result = []
    end

    def anything_until(token)
      regex = @tokens[token][:pattern]
      str = @scanner.scan_until(regex)
      str.gsub(regex, '')
    end

    def preview_string(pointer, truncate = 30)
      str = @scanner.string.dup.gsub(/\n/, ' ')
      str.insert(pointer, "(+)")
      start = pointer < truncate ? 0 : pointer - truncate
      finish = str.length - 1 < pointer + truncate ? str.length - 1 : pointer + truncate
      [
        ("..." unless start == 0),
        str[start .. finish],
        ("..." unless finish == str.length - 1)
      ].compact.join
    end

    def raise_error(message, pointer)
      raise ParseError, message + " String: '#{preview_string(pointer)}'"
    end

  end
end

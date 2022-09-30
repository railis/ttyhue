module TTYHue
  class TermColor

    LABELS = %w{black red green yellow blue magenta cyan white}

    def self.defs
      [].tap do |res|
        [false, true].each do |light|
          LABELS.each do |label|
            res << Theme.new(label, light)
          end
        end
        (0..255).each do |code|
          res << Gui.new(code)
        end
      end
    end

    def self.by_tag(tag_name)
      defs.select {|d| d.tag_name == tag_name}.first
    end

    class Base

      def inspect
        "#<TermColor @name=#{color_name} @tag=#{tag_name}>"
      end

    end

    class Theme < Base

      def initialize(label, light)
        @label = label
        @light = light
      end

      def color_name
        [('light' if @light), @label].compact.join("_").to_sym
      end

      def tag_name
        [('l' if @light), @label].compact.join
      end

    end

    class Gui < Base

      def initialize(code)
        @code = code
      end

      def color_name
        "gui_#{@code}".to_sym
      end

      def tag_name
        "gui#{@code.to_s}"
      end

    end

  end
end

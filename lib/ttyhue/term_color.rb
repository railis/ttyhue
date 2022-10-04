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

    def self.by_name(name)
      defs.select {|d| d.color_name == name}.first
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

      def term_hex(bg)
        color_index = TermColor::LABELS.index(@label)
        if @light
          bg ? "10#{color_index}" : "9#{color_index}"
        else
          bg ? "4#{color_index}" : "3#{color_index}"
        end
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

      def term_hex(bg)
        prefix = bg ? "48;5;" : "38;5;"
        prefix + @code.to_s
      end

    end

  end
end

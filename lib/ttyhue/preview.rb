module TTYHue
  class Preview

    class << self

      def preview_termcolors
        %w{black red green yellow blue magenta cyan white}.each do |c|
          ['', 'b'].each do |bg|
            ['', 'l'].each do |l|
              tag_name = "#{bg}#{l}#{c}"
              print TTYHue.c("  {#{tag_name}}  #{tag_name.ljust(12)}{/#{tag_name}}")
            end
          end
          print "\n"
        end
      end

      def preview_guicolors
        (1..256).each do |x|
          num = x - 1
          tag_name = "gui#{num}"
          print TTYHue.c(" {#{tag_name}}#{num.to_s.ljust(3)}{/#{tag_name}}")
          print "\n" if x % 16 == 0
        end
      end

    end

  end
end

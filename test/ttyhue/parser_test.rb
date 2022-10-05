require_relative "../test_helper.rb"

def assert_parsed(str, expected, opts = {})
  assert_equal expected, TTYHue::Parser.new(str, opts).parse
  TTYHue.set_style(nil)
end

describe TTYHue::Parser::Tag do

  describe ".valid?" do

    context "foreground" do

      should "allow theme colors" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{red}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/red}").valid?
      end

      should "allow light theme colors" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{lred}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/lred}").valid?
      end

      should "allow gui codes from 0 to 255" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{gui0}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{gui12}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{gui125}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{gui255}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/gui0}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/gui12}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/gui125}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/gui255}").valid?
      end

    end

    context "background" do

      should "allow theme colors" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{bred}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/red}").valid?
      end

      should "allow light theme colors" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{blred}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/blred}").valid?
      end

      should "allow gui codes from 0 to 255" do
        assert_equal true, TTYHue::Parser::ColorTag.new("{bgui0}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{bgui12}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{bgui125}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{bgui255}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui0}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui12}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui125}").valid?
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui255}").valid?
      end

    end

    context "invalid values" do

      should "not allow undefined labels" do
        assert_equal false, TTYHue::Parser::ColorTag.new("{unknown}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/unknown}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{unknown with other stuff}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/unknown with other stuff}").valid?
      end

      should "not allow invalid color codes" do
        assert_equal false, TTYHue::Parser::ColorTag.new("{gui-1}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{gui256}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{gui1233}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{bgui-1}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{bgui256}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{bgui1233}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/gui-1}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/gui256}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/gui1233}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/bgui-1}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/bgui256}").valid?
        assert_equal false, TTYHue::Parser::ColorTag.new("{/bgui1233}").valid?
      end

    end

  end

  describe "resolved values" do

    context "foreground" do

      should "resolve base theme colors" do
        assert_equal :red, TTYHue::Parser::ColorTag.new("{red}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{red}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{red}").bg
        assert_equal :red, TTYHue::Parser::ColorTag.new("{/red}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/red}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{/red}").bg
      end

      should "resolve light theme colors" do
        assert_equal :light_red, TTYHue::Parser::ColorTag.new("{lred}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{lred}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{lred}").bg
        assert_equal :light_red, TTYHue::Parser::ColorTag.new("{/lred}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/lred}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{/lred}").bg
      end

      should "resolve gui colors" do
        assert_equal :gui_123, TTYHue::Parser::ColorTag.new("{gui123}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{gui123}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{gui123}").bg
        assert_equal :gui_123, TTYHue::Parser::ColorTag.new("{/gui123}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/gui123}").closing
        assert_equal false, TTYHue::Parser::ColorTag.new("{/gui123}").bg
      end

    end

    context "background" do

      should "resolve base theme colors" do
        assert_equal :red, TTYHue::Parser::ColorTag.new("{bred}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{bred}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{bred}").bg
        assert_equal :red, TTYHue::Parser::ColorTag.new("{/bred}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bred}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bred}").bg
      end

      should "resolve light theme colors" do
        assert_equal :light_red, TTYHue::Parser::ColorTag.new("{blred}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{blred}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{blred}").bg
        assert_equal :light_red, TTYHue::Parser::ColorTag.new("{/blred}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/blred}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{/blred}").bg
      end

      should "resolve gui colors" do
        assert_equal :gui_123, TTYHue::Parser::ColorTag.new("{bgui123}").color_name
        assert_equal false, TTYHue::Parser::ColorTag.new("{bgui123}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{bgui123}").bg
        assert_equal :gui_123, TTYHue::Parser::ColorTag.new("{/bgui123}").color_name
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui123}").closing
        assert_equal true, TTYHue::Parser::ColorTag.new("{/bgui123}").bg
      end

    end

  end

end

describe TTYHue::Parser do

  context "base colors" do

    should "parse single color tag" do
      assert_parsed(
        "This is {red}red{/red}",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :red, bg: :default, str: "red" }
        ]
      )
    end

    should "parse single backgroud tag" do
      assert_parsed(
        "This is {bred}red{/bred}",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :default, bg: :red, str: "red" }
        ]
      )
    end

    should "parse multiple color tags" do
      assert_parsed(
        "This is {red}red{/red} and this is {blue}blue{/blue}",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :red, bg: :default, str: "red" },
          {fg: :default, bg: :default, str: " and this is " },
          {fg: :blue, bg: :default, str: "blue" }
        ]
      )
    end

    should "parse nested color tags" do
      assert_parsed(
        "This {green}all green but {cyan}cyan{/cyan} word{/green} fin",
        [
          {bg: :default, fg: :default, str: "This "},
          {bg: :default, fg: :green, str: "all green but "},
          {bg: :default, fg: :cyan, str: "cyan"},
          {bg: :default, fg: :green, str: " word"},
          {bg: :default, fg: :default, str: " fin"}
        ]
      )
    end

    should "parse both color and background tags" do
      assert_parsed(
        "This is {red}{bred}red with background{/bred}{/red}",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :red, bg: :red, str: "red with background"}
        ]
      )
    end

    should "parse nested color and background tags" do
      assert_parsed(
        "This is {red}red with {bred}background{/bred} cast{/red}",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :red, bg: :default, str: "red with "},
          {fg: :red, bg: :red, str: "background"},
          {fg: :red, bg: :default, str: " cast"}
        ]
      )
    end

  end

  context "color support" do

    should "support base term fg color" do
      assert_parsed(
        "Color {cyan}cyan{/cyan}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :cyan, bg: :default, str: "cyan"}
        ]
      )
    end

    should "support light term fg color" do
      assert_parsed(
        "Color {lcyan}cyan{/lcyan}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :light_cyan, bg: :default, str: "cyan"}
        ]
      )
    end

    should "support base term bg color" do
      assert_parsed(
        "Color {bcyan}cyan{/bcyan}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :default, bg: :cyan, str: "cyan"}
        ]
      )
    end

    should "support light term bg color" do
      assert_parsed(
        "Color {blcyan}cyan{/blcyan}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :default, bg: :light_cyan, str: "cyan"}
        ]
      )
    end

    should "support custom colors for fg" do
      assert_parsed(
        "Color {gui114}cyan{/gui114}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :gui_114, bg: :default, str: "cyan"}
        ]
      )
    end

    should "support custom colors for bg" do
      assert_parsed(
        "Color {bgui114}cyan{/bgui114}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :default, bg: :gui_114, str: "cyan"}
        ]
      )
    end

  end

  context "unclosed tags" do

    should "work with unclosed tags" do
      assert_parsed(
        "This is {blue}blue",
        [
          {fg: :default, bg: :default, str: "This is "},
          {fg: :blue, bg: :default, str: "blue"}
        ]
      )
    end

    should "ignore alone closing tags" do
      assert_parsed(
        "This is {/red}red",
        [
          {fg: :default, bg: :default, str: "This is red"},
        ]
      )
    end

    should "remember the color when multiple tags are overflowing" do
      assert_parsed(
        "{blue}Overflowing blue {red}now red with {green}some green{/red} and green{/green} and blue",
        [
          {fg: :blue, bg: :default, str: "Overflowing blue "},
          {fg: :red, bg: :default, str: "now red with "},
          {fg: :green, bg: :default, str: "some green and green"},
          {fg: :blue, bg: :default, str: " and blue"}
        ]
      )
    end

  end

  context "styles" do

    should "ignore styles when no styles defined" do
      assert_parsed(
        "{header}This is header{/header} and this is {footer}footer{/footer}",
        [
          {fg: :default, bg: :default, str: "{header}This is header{/header} and this is {footer}footer{/footer}"}
        ]
      )
    end

    should "use styles when styles defined" do
      assert_parsed(
        "{header}This is header{/header} and this is {footer}footer{/footer}",
        [
          {fg: :red, bg: :default, str: "This is header"},
          {fg: :default, bg: :default, str: " and this is "},
          {fg: :blue, bg: :default, str: "footer"}
        ],
        {
          header: {fg: :red},
          footer: {fg: :blue}
        }
      )
    end

    should "allow applying both fg and bg styles" do
      assert_parsed(
        "{header}This is header{/header}",
        [
          {fg: :blue, bg: :red, str: "This is header"}
        ],
        {
          header: {fg: :blue, bg: :red}
        }
      )
    end

    should "allow using global styles" do
      TTYHue.set_style(header: {fg: :blue})
      assert_parsed(
        "{header}This is header{/header}",
        [
          {fg: :blue, bg: :default, str: "This is header"}
        ]
      )
    end

    should "allow using both global and local styles" do
      TTYHue.set_style(header: {fg: :red})
      assert_parsed(
        "{header}This is header{/header} and this is {footer}footer{/footer}",
        [
          {fg: :red, bg: :default, str: "This is header"},
          {fg: :default, bg: :default, str: " and this is "},
          {fg: :blue, bg: :default, str: "footer"}
        ],
        {
          footer: {fg: :blue}
        }
      )
    end

  end

  context "corner cases" do

    should "handle solo tag opening gracefully" do
      assert_parsed(
        "Some {red}red{/red} some { and some {blue}blue{/blue}",
        [
          {fg: :default, bg: :default, str: "Some "},
          {fg: :red, bg: :default, str: "red"},
          {fg: :default, bg: :default, str: " some { and some "},
          {fg: :blue, bg: :default, str: "blue"}
        ]
      )
    end

    should "handle nested tags" do
      assert_parsed(
        "Some {green}{blue}{cyan}{red}red{/red}{/cyan}{/blue}{/green}",
        [
          {fg: :default, bg: :default, str: "Some "},
          {fg: :red, bg: :default, str: "red"}
        ]
      )
    end

  end

end

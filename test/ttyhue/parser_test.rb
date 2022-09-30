require_relative "../test_helper.rb"

def assert_parsed(str, expected)
  assert_equal expected, TTYHue::Parser.new(str).parse
end

def assert_parse_error(str, message)
  err = assert_raises TTYHue::Parser::ParseError do
    TTYHue::Parser.new(str).parse
  end
  assert_equal message, err.message
end

describe TTYHue::Parser::Tag do

  describe ".valid?" do

    context "foreground" do

      should "allow theme colors" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{red}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/red}")
      end

      should "allow light theme colors" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{lred}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/lred}")
      end

      should "allow gui codes from 0 to 255" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{gui0}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{gui12}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{gui125}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{gui255}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/gui0}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/gui12}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/gui125}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/gui255}")
      end

    end

    context "background" do

      should "allow theme colors" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{bred}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/red}")
      end

      should "allow light theme colors" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{blred}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/blred}")
      end

      should "allow gui codes from 0 to 255" do
        assert_equal true, TTYHue::Parser::Tag.valid?("{bgui0}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{bgui12}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{bgui125}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{bgui255}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/bgui0}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/bgui12}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/bgui125}")
        assert_equal true, TTYHue::Parser::Tag.valid?("{/bgui255}")
      end

    end

    context "invalid values" do

      should "not allow undefined labels" do
        assert_equal false, TTYHue::Parser::Tag.valid?("{unknown}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/unknown}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{unknown with other stuff}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/unknown with other stuff}")
      end

      should "not allow invalid color codes" do
        assert_equal false, TTYHue::Parser::Tag.valid?("{gui-1}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{gui256}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{gui1233}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{bgui-1}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{bgui256}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{bgui1233}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/gui-1}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/gui256}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/gui1233}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/bgui-1}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/bgui256}")
        assert_equal false, TTYHue::Parser::Tag.valid?("{/bgui1233}")
      end

    end

  end

  describe "resolved values" do

    context "foreground" do

      should "resolve base theme colors" do
        assert_equal :red, TTYHue::Parser::Tag.new("{red}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{red}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{red}").bg
        assert_equal :red, TTYHue::Parser::Tag.new("{/red}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/red}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{/red}").bg
      end

      should "resolve light theme colors" do
        assert_equal :light_red, TTYHue::Parser::Tag.new("{lred}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{lred}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{lred}").bg
        assert_equal :light_red, TTYHue::Parser::Tag.new("{/lred}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/lred}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{/lred}").bg
      end

      should "resolve gui colors" do
        assert_equal :gui_123, TTYHue::Parser::Tag.new("{gui123}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{gui123}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{gui123}").bg
        assert_equal :gui_123, TTYHue::Parser::Tag.new("{/gui123}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/gui123}").closing
        assert_equal false, TTYHue::Parser::Tag.new("{/gui123}").bg
      end

    end

    context "background" do

      should "resolve base theme colors" do
        assert_equal :red, TTYHue::Parser::Tag.new("{bred}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{bred}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{bred}").bg
        assert_equal :red, TTYHue::Parser::Tag.new("{/bred}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/bred}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{/bred}").bg
      end

      should "resolve light theme colors" do
        assert_equal :light_red, TTYHue::Parser::Tag.new("{blred}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{blred}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{blred}").bg
        assert_equal :light_red, TTYHue::Parser::Tag.new("{/blred}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/blred}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{/blred}").bg
      end

      should "resolve gui colors" do
        assert_equal :gui_123, TTYHue::Parser::Tag.new("{bgui123}").color_name
        assert_equal false, TTYHue::Parser::Tag.new("{bgui123}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{bgui123}").bg
        assert_equal :gui_123, TTYHue::Parser::Tag.new("{/bgui123}").color_name
        assert_equal true, TTYHue::Parser::Tag.new("{/bgui123}").closing
        assert_equal true, TTYHue::Parser::Tag.new("{/bgui123}").bg
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

  #context "errors" do

  #  should "raise error when unknown tag opening is used" do
  #    assert_parse_error(
  #      "Color {unknown}color{unknown}",
  #      "Unexpected string 'unknown' after `{`. Expecting color value. String: 'Color {(+)unknown}color{unknown}'"
  #    )
  #  end

  #  should "raise error when unknown tag opening starting with correct color is used" do
  #    assert_parse_error(
  #      "Color {redsomethin021g}color{/red}",
  #      "Unexpected string 'somethin021g' after color:red. Expecting '}'. String: 'Color {red(+)somethin021g}color{/red}'"
  #    )
  #  end

  #  should "raise error when unknown tag closing is used" do
  #    assert_parse_error(
  #      "Color {blue}color{/unknown}",
  #      "Unexpected string 'unknown' after `{/`. Expecting color:blue. String: 'Color {blue}color{/(+)unknown}'"
  #    )
  #  end

  #  should "raise error when incorrect color tag is closed" do
  #    assert_parse_error(
  #      "Color {red}color {blue} blue{/red}",
  #      "Unexpected color:red tag closing. Expected color:blue String: '...or {red}color {blue} blue{/red(+)}'"
  #    )
  #  end

  #  should "raise error when incorrect custom color tag is closed" do
  #    assert_parse_error(
  #      "Color {c12}color {c134} blue{/c12}",
  #      "Unexpected color:12 tag closing. Expected color:134 String: '...or {c12}color {c134} blue{/c12(+)}'"
  #    )
  #  end

  #  should "truncate string preview in longer strings" do
  #    str = <<~EOS
  #      Lorem ipsum dolor sit amoent
  #      Lorem ipsum dolor sit amoent
  #      Lorem ipsum dolor sit amoent
  #      Color {unknown}color{unknown}
  #      Lorem ipsum dolor sit amoent
  #      Lorem ipsum dolor sit amoent
  #      Lorem ipsum dolor sit amoent
  #    EOS
  #    assert_parse_error(
  #      str,
  #      "Unexpected string 'unknown' after `{`. Expecting color value. String: '...ipsum dolor sit amoent Color {(+)unknown}color{unknown} Lorem...'"
  #    )
  #  end

  #end


end

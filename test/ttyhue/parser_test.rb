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
        "Color {c114}cyan{/c114}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: 114, bg: :default, str: "cyan"}
        ]
      )
    end

    should "support custom colors for bg" do
      assert_parsed(
        "Color {bc114}cyan{/bc114}",
        [
          {fg: :default, bg: :default, str: "Color "},
          {fg: :default, bg: 114, str: "cyan"}
        ]
      )
    end

  end

  context "errors" do

    should "raise error when unknown tag opening is used" do
      assert_parse_error(
        "Color {unknown}color{unknown}",
        "Unexpected string 'unknown' after `{`. Expecting color value. String: 'Color {(+)unknown}color{unknown}'"
      )
    end

    should "raise error when unknown tag opening starting with correct color is used" do
      assert_parse_error(
        "Color {redsomethin021g}color{/red}",
        "Unexpected string 'somethin021g' after color:red. Expecting '}'. String: 'Color {red(+)somethin021g}color{/red}'"
      )
    end

    should "raise error when unknown tag closing is used" do
      assert_parse_error(
        "Color {blue}color{/unknown}",
        "Unexpected string 'unknown' after `{/`. Expecting color:blue. String: 'Color {blue}color{/(+)unknown}'"
      )
    end

    should "raise error when incorrect color tag is closed" do
      assert_parse_error(
        "Color {red}color {blue} blue{/red}",
        "Unexpected color:red tag closing. Expected color:blue String: '...or {red}color {blue} blue{/red(+)}'"
      )
    end

    should "raise error when incorrect custom color tag is closed" do
      assert_parse_error(
        "Color {c12}color {c134} blue{/c12}",
        "Unexpected color:12 tag closing. Expected color:134 String: '...or {c12}color {c134} blue{/c12(+)}'"
      )
    end

    should "truncate string preview in longer strings" do
      str = <<~EOS
        Lorem ipsum dolor sit amoent
        Lorem ipsum dolor sit amoent
        Lorem ipsum dolor sit amoent
        Color {unknown}color{unknown}
        Lorem ipsum dolor sit amoent
        Lorem ipsum dolor sit amoent
        Lorem ipsum dolor sit amoent
      EOS
      assert_parse_error(
        str,
        "Unexpected string 'unknown' after `{`. Expecting color value. String: '...ipsum dolor sit amoent Color {(+)unknown}color{unknown} Lorem...'"
      )
    end

  end


end

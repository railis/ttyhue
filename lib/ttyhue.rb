require_relative "ttyhue/term_color"
require_relative "ttyhue/parser"
require_relative "ttyhue/colorizer"
require_relative "ttyhue/preview"

module TTYHue

  def self.c(str)
    TTYHue::Colorizer.colorize(str)
  end

  def self.preview_termcolors
    Preview.preview_termcolors
  end

  def self.preview_guicolors
    Preview.preview_guicolors
  end

end

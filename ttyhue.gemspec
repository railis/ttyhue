require_relative "lib/ttyhue/version"

Gem::Specification.new do |spec|
  spec.name          = "ttyhue"
  spec.version       = TTYHue::VERSION
  spec.authors       = ["Dominik Sito"]
  spec.email         = ["dominik.sito@gmail.com"]

  spec.summary       = "Ruby gem for colorizing terminal output, supporting terminal theme colors as well as more fine-grained gui colors palette."
  spec.description   = "Ruby gem for colorizing terminal output, supporting terminal theme colors as well as more fine-grained gui colors palette."
  spec.homepage      = "https://github.com/railis/ttyhue"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/railis/ttyhue"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/railis/ttyhue/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "5.16.3"
  spec.add_development_dependency "minitest-reporters", "1.5.0"
  spec.add_development_dependency "shoulda-context", "2.0.0"
end

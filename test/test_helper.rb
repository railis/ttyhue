require "minitest/autorun"
require "minitest/reporters"
require "shoulda-context"

require_relative "../lib/ttyhue"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "ejs"
require "test/unit"

FUNCTION_PATTERN = /^function\s*\(.*?\)\s*\{(.*?)\}$/

BRACE_SYNTAX = {
  :evaluation_pattern    => /\{\{([\s\S]+?)\}\}/,
  :interpolation_pattern => /\{\{=([\s\S]+?)\}\}/
}

QUESTION_MARK_SYNTAX = {
  :evaluation_pattern    => /<\?([\s\S]+?)\?>/,
  :interpolation_pattern => /<\?=([\s\S]+?)\?>/
}

module TestHelper
  def test(name, &block)
    define_method("test #{name.inspect}", &block)
  end
end

class EJSCompilationTest < Test::Unit::TestCase
  extend TestHelper

  test "compile" do
    result = EJS.compile("Hello <%= name %>")
    assert_match FUNCTION_PATTERN, result
    assert_no_match(/Hello \<%= name %\>/, result)
  end

  test "compile with custom syntax" do
    standard_result = EJS.compile("Hello <%= name %>")
    braced_result   = EJS.compile("Hello {{= name }}", BRACE_SYNTAX)

    assert_match FUNCTION_PATTERN, braced_result
    assert_equal standard_result, braced_result
  end
end

class EJSCustomPatternTest < Test::Unit::TestCase
  extend TestHelper

  def setup
    @original_evaluation_pattern = EJS.evaluation_pattern
    @original_interpolation_pattern = EJS.interpolation_pattern
    EJS.evaluation_pattern = BRACE_SYNTAX[:evaluation_pattern]
    EJS.interpolation_pattern = BRACE_SYNTAX[:interpolation_pattern]
  end

  def teardown
    EJS.interpolation_pattern = @original_interpolation_pattern
    EJS.evaluation_pattern = @original_evaluation_pattern
  end

  test "compile" do
    result = EJS.compile("Hello {{= name }}")
    assert_match FUNCTION_PATTERN, result
    assert_no_match(/Hello \{\{= name \}\}/, result)
  end

  test "compile with custom syntax" do
    standard_result = EJS.compile("Hello {{= name }}")
    question_result = EJS.compile("Hello <?= name ?>", QUESTION_MARK_SYNTAX)

    assert_match FUNCTION_PATTERN, question_result
    assert_equal standard_result, question_result
  end
end

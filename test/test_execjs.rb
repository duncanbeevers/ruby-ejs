begin
require 'execjs'

class EJSEvaluationTest < Test::Unit::TestCase
  extend TestHelper

  test "quotes" do
    template = "<%= thing %> is gettin' on my noives!"
    assert_equal "This is gettin' on my noives!", EJS.evaluate(template, :thing => "This")
  end

  test "backslashes" do
    template = "<%= thing %> is \\ridanculous"
    assert_equal "This is \\ridanculous", EJS.evaluate(template, :thing => "This")
  end

  test "iteration" do
    template = "<ul><%
      for (var i = 0; i < people.length; i++) {
    %><li><%= people[i] %></li><% } %></ul>"
    result = EJS.evaluate(template, :people => ["Moe", "Larry", "Curly"])
    assert_equal "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", result
  end

  test "without interpolation" do
    template = "<div><p>Just some text. Hey, I know this is silly but it aids consistency.</p></div>"
    assert_equal template, EJS.evaluate(template)
  end

  test "two quotes" do
    template = "It's its, not it's"
    assert_equal template, EJS.evaluate(template)
  end

  test "quote in statement and body" do
    template = "<%
      if(foo == 'bar'){
    %>Statement quotes and 'quotes'.<% } %>"
    assert_equal "Statement quotes and 'quotes'.", EJS.evaluate(template, :foo => "bar")
  end

  test "newlines and tabs" do
    template = "This\n\t\tis: <%= x %>.\n\tok.\nend."
    assert_equal "This\n\t\tis: that.\n\tok.\nend.", EJS.evaluate(template, :x => "that")
  end


  test "braced iteration" do
    template = "<ul>{{ for (var i = 0; i < people.length; i++) { }}<li>{{= people[i] }}</li>{{ } }}</ul>"
    result = EJS.evaluate(template, { :people => ["Moe", "Larry", "Curly"] }, BRACE_SYNTAX)
    assert_equal "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", result
  end

  test "braced quotes" do
    template = "It's its, not it's"
    assert_equal template, EJS.evaluate(template, {}, BRACE_SYNTAX)
  end

  test "braced quotes in statement and body" do
    template = "{{ if(foo == 'bar'){ }}Statement quotes and 'quotes'.{{ } }}"
    assert_equal "Statement quotes and 'quotes'.", EJS.evaluate(template, { :foo => "bar" }, BRACE_SYNTAX)
  end


  test "question-marked iteration" do
    template = "<ul><? for (var i = 0; i < people.length; i++) { ?><li><?= people[i] ?></li><? } ?></ul>"
    result = EJS.evaluate(template, { :people => ["Moe", "Larry", "Curly"] }, QUESTION_MARK_SYNTAX)
    assert_equal "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", result
  end

  test "question-marked quotes" do
    template = "It's its, not it's"
    assert_equal template, EJS.evaluate(template, {}, QUESTION_MARK_SYNTAX)
  end

  test "question-marked quote in statement and body" do
    template = "<? if(foo == 'bar'){ ?>Statement quotes and 'quotes'.<? } ?>"
    assert_equal "Statement quotes and 'quotes'.", EJS.evaluate(template, { :foo => "bar" }, QUESTION_MARK_SYNTAX)
  end
end

rescue LoadError
  puts "Install execjs in order to run execjs evaluation tests"
end


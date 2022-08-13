require_relative 'rule'
require 'open3'

def process_file(file_name, rule_classes = Rule.subclasses)
  return unless File.exist?(file_name)

  code = File.read(file_name)
  rule_classes.each { |rule_class| code = process_rule(rule_class, code) }

  rewritten_file_name = file_name.gsub(/\./, '_rewrite.')

  rewritten_file = File.open(rewritten_file_name, 'w')
  rewritten_file.write(code)
  rewritten_file.close

  Open3.capture2("rubocop -a #{rewritten_file_name}")
end

def process_rule(rule_class, code)
  source = RuboCop::ProcessedSource.new(code, 3.1)
  source_buffer = source.buffer
  rewriter = Parser::Source::TreeRewriter.new(source_buffer)
  rule = rule_class.new(rewriter)
  source.ast.each_node { |node| rule.process(node) }
  rewriter.process
end

# process 'file.rb'
process_file('parsing/file.rb')


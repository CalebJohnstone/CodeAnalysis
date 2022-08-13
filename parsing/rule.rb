require 'parser/current'
require 'rubocop'

class Rule < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def initialize(rewriter)
    super()
    @rewriter = rewriter
  end

  def replace(range, content)
    @rewriter.replace(range, content)
  end

  def remove(range)
    @rewriter.remove(range)
  end

  def create_range(begin_pos, end_pos)
    Parser::Source::Range.new(@rewriter.source_buffer, begin_pos, end_pos)
  end
end

class RemoveDebuggingCode < Rule
  def on_send(node)
    remove(node.loc.expression) if node.method?(:puts)

    # TODO: replace must check
    # if logging for this type of rule
    #   log it a summary file
    #
    # replace
  end
end

module Parsing
  class BaseCheck < Parser::AST::Processor
    include RuboCop::AST::Traversal

    attr_accessor :rewriter

    def initialize(rewriter)
      super()
      @rewriter = rewriter
    end

    def replace(range, content)
      rewriter.replace(range, content)
    end

    def remove(range)
      rewriter.remove(range)
    end

    def create_range(begin_pos, end_pos)
      Parser::Source::Range.new(rewriter.source_buffer, begin_pos, end_pos)
    end
  end
end

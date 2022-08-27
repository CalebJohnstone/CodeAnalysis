module Parsing
  class Process
    class << self
      def process_file(file_name, check_classes = BaseCheck.descendants)
        file_name = "#{Dir.pwd}/lib/files/#{file_name}.rb"
        return unless File.exist?(file_name)

        code = File.read(file_name)
        check_classes.each { |check_class| code = process_check(check_class, code) }

        rewritten_file_name = file_name.gsub(/\./, '_rewrite.')

        rewritten_file = File.open(rewritten_file_name, 'w')
        rewritten_file.write(code)
        rewritten_file.close

        Open3.capture2("rubocop -a #{rewritten_file_name}")
      end

      def process_check(check_class, code)
        source = RuboCop::ProcessedSource.new(code, 3.1)
        source_buffer = source.buffer
        rewriter = Parser::Source::TreeRewriter.new(source_buffer)
        check = check_class.new(rewriter)
        source.ast.each_node { |node| check.process(node) }
        rewriter.process
      end
    end
  end
end

#process_file('parsing/file.rb')


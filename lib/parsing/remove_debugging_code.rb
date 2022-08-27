class Parsing::RemoveDebuggingCode < Parsing::BaseCheck
  def on_send(node)
    remove(node.loc.expression) if node.method?(:puts)
  end
end

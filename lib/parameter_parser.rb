# Parses endpoint parameters
class ParameterParser
  def parse(path)
    parts = split_parts path
    { path: parts[:path], parameters: parts[:param_string] }
  end

  def split_parts(path)
    parts = path.split '?'
    { path: parts[0], param_string: parts[1] }
  end
end
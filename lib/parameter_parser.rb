# Parses endpoint parameters
class ParameterParser
  def parse(path)
    parts = split_parts path
    parameters = split_parameters parts[:param_string]
    { path: parts[:path], parameters: parameters }
  end

  def split_parts(path)
    parts = path.split '?'
    { path: parts[0], param_string: parts[1] }
  end

  def split_parameters(parameters)
    return nil if parameters.nil?
    parts = parameters.split '='
    params = {}

    params[parts[0]] = parts[1]

    params
  end
end

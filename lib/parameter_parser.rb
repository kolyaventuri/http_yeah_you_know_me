# Parses endpoint parameters
class ParameterParser
  def parse(path)
    parts = split_parts path
    parameters = split_parameters parts[:param_string]
    { endpoint: parts[:endpoint], parameters: parameters }
  end

  def split_parts(path)
    parts = path.split '?'
    { endpoint: parts[0], param_string: parts[1] }
  end

  def split_parameters(parameters)
    return nil if parameters.nil?
    parts = parameters.split '&'
    params = {}

    parts.each do |part|
      param = part.split '='
      params[param[0]] = param[1]
    end

    params
  end
end

require_relative 'parameter_parser'
# Parses incoming body object into hash
class BodyParser
  def parse(body, content_type = 'x-www-form-urlencoded')
    if content_type == 'x-www-form-urlencoded'
      split_parameters body
    else
      nil
    end
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
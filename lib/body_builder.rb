# Builds response body
class BodyBuilder
  def body(content, headers)
    response = [content, '<pre>']
    response.concat(headers)
    response.push('</pre>')
    response.join('\r\n')
  end
end
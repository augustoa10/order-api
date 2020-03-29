class Http::Response
  include Virtus.model

  attribute :body, String
  attribute :status, Integer
  attribute :headers, Hash, default: {}

  def server_error?
    status >= 500
  end

  def client_error?
    status >= 400 && status < 500
  end

  def ok?
    status >= 200 && status < 300
  end
end

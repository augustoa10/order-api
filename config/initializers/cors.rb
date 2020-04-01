if ENV["ORDER_API_ALLOWED_REQUEST_ORIGIN"]
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins *ENV["ORDER_API_ALLOWED_REQUEST_ORIGIN"].split(",").map(&:strip)
      resource "*",
        headers: :any,
        methods: %i(get post put patch delete options head)
    end
  end
end

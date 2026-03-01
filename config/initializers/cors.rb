# frozen_string_literal: true

# Allow all origins (e.g. frontend on same machine, other device on LAN).
# Reflects the request origin so credentials (cookies, Authorization) work.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins { |source, _env| source }
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true,
             expose: %w[Authorization]
  end
end

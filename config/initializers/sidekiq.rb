host = ENV['REDIS_HOST']
port = ENV['REDIS_PORT']

redis_ready = host.present? and port.present?

redis_url = if redis_ready
  "redis://#{host}:#{port}"
else
  "redis://localhost:6379"
end

sidekiq_config = { url: redis_url } # url: 'redis://redis.example.com:7372/0'

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

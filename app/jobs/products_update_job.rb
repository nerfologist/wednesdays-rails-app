# frozen_string_literal: true

class ProductsUpdateJob < ActiveJob::Base
  extend ShopifyAPI::Webhooks::Handler

  class << self
    def handle(topic:, shop:, body:)
      perform_later(topic: topic, shop_domain: shop, webhook: body)
    end
  end

  def perform(topic:, shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")

      raise ActiveRecord::RecordNotFound, "Shop Not Found"
    end

    shop.with_shopify_session do
      puts "products/update received, payload #{webhook}"
      order_gid = webhook["admin_graphql_api_id"]
      AddTags.call(id: order_gid, tags: [ "processed-by-rails-webhook" ])
    end
  end
end

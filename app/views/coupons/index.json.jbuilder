json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :promo_code, :discount, :coupon_type, :event_id
  json.url coupon_url(coupon, format: :json)
end

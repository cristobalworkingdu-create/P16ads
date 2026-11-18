-- Convbox 订单触点（{{ORDER_IDS}} 由 scripts/order_ids.py 生成）
SELECT order_id, CAST(order_time AS STRING) order_time, CAST(event_time AS STRING) event_time, channel, channel_group, campaign_name, adset_name, ad_name,
  REGEXP_EXTRACT(page_url, r'^https?://[^/]+(/[^?#]*)') page_path, REPEAT('.', 5000) _pad
FROM `merach-452802.convbox.order_adclicks`
WHERE shop_name='merach-fitness-store' AND order_time >= '2026-10-20' AND order_id IN ({{ORDER_IDS}})
ORDER BY order_id, event_time

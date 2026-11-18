-- Shopify 订单行：含无氧系列或地垫套装的美国站订单（截至 {{END}}，每个订单行取最新快照）
SELECT CAST(order_id AS STRING) order_id, order_name, CAST(created_at AS STRING) created_at, CAST(product_id AS STRING) product_id, sku, quantity, price, discount_amount, net_amount, if_cannel, if_refund, refund_amount, REPEAT('.', 10000) _pad
FROM `merach-452802.merach_shopify.dwd_shopify_order_item_a`
WHERE dt >= '2026-10-20' AND country_code='US' AND CAST(product_id AS STRING) IN ('10363227209903','10364097593519','10363239366831','10330238812335','10363226587311','10363225964719','10363225604271','10360842453167','10361139953839')
  AND created_at BETWEEN '2026-10-20' AND '{{END}}'
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id, sku ORDER BY dt DESC) = 1

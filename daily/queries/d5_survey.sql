-- 下单问卷（{{ORDER_IDS}} 由 scripts/order_ids.py 生成）
SELECT order_id, order_name, question, answer, note, REPEAT('.', 30000) _pad
FROM `merach-452802.convbox.order_survey`
WHERE shop_name='merach-fitness-store' AND order_id IN ({{ORDER_IDS}})

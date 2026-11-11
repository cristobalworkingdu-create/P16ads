-- 数据集 attr_campaigns：付费广告归因（Convbox，U 型，Campaign 层级），位于 us-central1
WITH prod AS (
  SELECT * FROM UNNEST([STRUCT('10363227209903' AS product_id, 'P15' AS spu), ('10364097593519','P15'), ('10363239366831','P15'),
    ('10330238812335','P16'), ('10363226587311','P17'), ('10363225964719','P17'), ('10363225604271','P17'), ('10360842453167','P18')])
),
names AS (SELECT campaign_id, ANY_VALUE(campaign_name) campaign_name FROM `merach-452802.convbox.media_campaign_info` WHERE shop_name='merach-fitness-store' GROUP BY 1)
SELECT p.spu, REPLACE(par.channel, 'Facebook Ads', 'Meta Ads') AS channel, par.campaign_id, IFNULL(n.campaign_name, '(未匹配到名称)') AS campaign_name,
  ROUND(SUM(par.sessions),1) AS sessions, ROUND(SUM(par.atc_sessions),1) AS atc, ROUND(SUM(par.ic_sessions),1) AS checkout,
  ROUND(SUM(par.product_sold),3) AS orders_attr, ROUND(SUM(par.product_sales),2) AS revenue_attr
FROM `merach-452802.convbox.product_ad_report_v2` par
JOIN prod p ON p.product_id = par.product_id
LEFT JOIN names n ON n.campaign_id = par.campaign_id
WHERE par.ondate BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND par.shop_name='merach-fitness-store' AND par.attribution_model='ushaped'
  AND par.report_level='campaign' AND par.channel_group='Paid Ads'
GROUP BY 1,2,3,4

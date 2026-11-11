-- 数据集 meta_ads（第 1 部分）：P16 专投 Meta 广告的 Convbox 归因（广告层级，U 型），位于 us-central1
WITH prod AS (
  SELECT * FROM UNNEST([STRUCT('10363227209903' AS product_id, 'P15' AS spu), ('10364097593519','P15'), ('10363239366831','P15'),
    ('10330238812335','P16'), ('10363226587311','P17'), ('10363225964719','P17'), ('10363225604271','P17'), ('10360842453167','P18')])
)
SELECT ai.campaign_name, ai.adset_name, ai.ads_name AS ad_name, p.spu,
  ROUND(SUM(par.sessions),1) AS sessions, ROUND(SUM(par.atc_sessions),1) AS atc, ROUND(SUM(par.ic_sessions),1) AS checkout,
  ROUND(SUM(par.product_sold),3) AS orders_attr, ROUND(SUM(par.product_sales),2) AS revenue_attr
FROM `merach-452802.convbox.product_ad_report_v2` par
JOIN prod p ON p.product_id = par.product_id
LEFT JOIN `merach-452802.convbox.media_ad_info` ai ON ai.ads_id = par.ad_id AND ai.adset_id = par.adgroup_id AND ai.campaign_id = par.campaign_id
WHERE par.ondate BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND par.shop_name='merach-fitness-store' AND par.attribution_model='ushaped'
  AND par.channel='Facebook Ads' AND par.report_level='ad' AND REGEXP_CONTAINS(IFNULL(ai.campaign_name,''), r'P16')
GROUP BY 1,2,3,4

-- 数据集 meta_ads（第 2 部分）：P16 专投 Meta 广告的花费与曝光（广告层级），位于 US
SELECT campaign_name, adset_name, ad_name, ROUND(SUM(spend),2) AS spend, SUM(impressions) AS impressions, SUM(link_clicks) AS clicks,
  SUM(landing_page_views) AS lpv, SUM(video_play_actions_3_second_video_views) AS video_3s
FROM `merach-452802.facebook_ads.facebook_ad_insights`
WHERE DATE(date_start) BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND REGEXP_CONTAINS(campaign_name, r'P16')
GROUP BY 1,2,3

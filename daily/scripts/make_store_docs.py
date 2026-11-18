"""生成写入 Claude 看板的数据集文档。用法：python3 make_store_docs.py <输出目录> <END> sales=<blob> funnel=<blob> orders=<blob> paths=<blob>"""
import json, sys, os, datetime
OUT, END = sys.argv[1], sys.argv[2]
blobs = dict(a.split('=', 1) for a in sys.argv[3:])
now = datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
by = 'Claude（BigQuery 查询快照，2026-10-20 至 %s，美西完整日）' % END
sched = '每日更新：美西完整日结束后由定时任务重新导出并替换本文件；也可让 Claude 手动运行一次。'
D = {
 'sales': ('Shopify 每日销量与销售额', '美国站 P15–P18 与地垫套装按 SKU 的每日订单、销量、折后销售额（miaoda.total_site_sku_by_date，不含测试 SKU 与赠品）。'),
 'funnel': ('Convbox 商品漏斗（按日、按渠道）', 'Convbox product_report_v2：每个商品每天按渠道的商品浏览、会话、加购与发起结账（事件与会话两种口径）及 U 型归因成交。'),
 'orders': ('Shopify 订单明细', '含无氧系列或地垫套装的美国站订单行（merach_shopify.dwd_shopify_order_item_a，已排除取消单），附下单问卷答案（convbox.order_survey）。'),
 'paths': ('订单归因触点', 'Convbox order_adclicks：上述订单下单前的触点，连续落在同一渠道、同一 Campaign 的点击合并为一步，时间为美西时间。'),
}
for k, (t, d) in D.items():
    b = blobs[k].replace('/_blob/', '')
    doc = {'title': t, 'description': d, 'source': {'kind': 'file', 'url': '/_blob/' + b, 'name': k + '.csv', 'format': 'csv'},
           'updated': {'at': now, 'by': by}, 'fixed': True, 'schedule': sched}
    json.dump(doc, open(os.path.join(OUT, 'ds_%s.json' % k), 'w'), ensure_ascii=False)
print('ok', now)

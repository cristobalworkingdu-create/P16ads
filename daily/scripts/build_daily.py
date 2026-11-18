"""把 BigQuery 导出的 raw_*.csv 整理成看板数据。用法：python3 build_daily.py <工作目录> <输出目录>
工作目录需有 raw_sales.csv、raw_funnel.csv、raw_items.csv、raw_paths.csv、raw_survey.csv。"""
import csv, collections, datetime, sys, os
from zoneinfo import ZoneInfo
W, OUT = sys.argv[1], sys.argv[2]
PT = ZoneInfo('America/Los_Angeles')
def rd(f): return list(csv.DictReader(open(os.path.join(W, f))))
def wr(f, cols, rows):
    w = csv.DictWriter(open(os.path.join(OUT, f), 'w', newline=''), fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(rows)
def item(sku):
    if 'P16B3' in sku: return 'P16 Elite'
    if 'P16B2' in sku: return 'P16 Pro'
    if '2603' in sku: return '地垫'
    if '2604' in sku: return '收边条'
    if 'BOGOS' in sku: return 'P15 赠品'
    if sku.startswith('MR-P15'): return 'P15 杠铃片'
    if sku.startswith('MR-P17'): return 'P17'
    if sku.startswith('MR-P18'): return 'P18 训练凳'
    return sku
def spu_of(sku):
    return '地垫套装' if ('2603' in sku or '2604' in sku) else sku[3:6]
SP = {'10363227209903': 'P15', '10364097593519': 'P15', '10363239366831': 'P15', '10330238812335': 'P16', '10363226587311': 'P17',
      '10363225964719': 'P17', '10363225604271': 'P17', '10360842453167': 'P18', '10361139953839': '地垫套装'}
S = [dict(date=x['date'], spu=spu_of(x['sku']), sku=x['sku'], item=item(x['sku']), orders=x['orders'], units=x['units'], net_sales=x['net_sales']) for x in rd('raw_sales.csv')]
S.sort(key=lambda r: (r['date'], r['spu'], r['sku']))
wr('sales.csv', ['date', 'spu', 'item', 'sku', 'orders', 'units', 'net_sales'], S)
F = rd('raw_funnel.csv'); F.sort(key=lambda r: (r['date'], r['spu'], r['channel_group'], r['channel']))
wr('funnel.csv', ['date', 'spu', 'channel_group', 'channel', 'product_views', 'sessions', 'atc_sessions', 'ic_sessions', 'atc_events', 'ic_events', 'sold_attr', 'sales_attr'], F)
survey = {}
for x in rd('raw_survey.csv'):
    survey[x['order_id']] = x['answer'] + ('：' + x['note'] if x.get('note') else '')
O = []
for x in rd('raw_items.csv'):
    if x['if_cannel'] != '未取消': continue
    O.append(dict(order_id=x['order_id'], order_name=x['order_name'], date=x['created_at'][:10], spu=SP[x['product_id']], item=item(x['sku']), sku=x['sku'],
                  quantity=x['quantity'], net_amount=x['net_amount'], gift='1' if 'BOGOS' in x['sku'] else '0', refunded='1' if x['if_refund'] == '退款订单' else '0',
                  survey=survey.get(x['order_id'], '')))
O.sort(key=lambda r: (r['date'], r['order_name'], r['spu']))
wr('orders.csv', ['order_id', 'order_name', 'date', 'spu', 'item', 'sku', 'quantity', 'net_amount', 'gift', 'refunded', 'survey'], O)
P = []; by = collections.defaultdict(list)
for x in rd('raw_paths.csv'): by[x['order_id']].append(x)
for oid, xs in by.items():
    xs.sort(key=lambda r: r['event_time'])
    seq = []
    for x in xs:
        k = (x['channel'], x['campaign_name'] or '')
        t = datetime.datetime.fromisoformat(x['event_time'].replace('+00', '+00:00')).astimezone(PT)
        if seq and seq[-1]['k'] == k: seq[-1]['clicks'] += 1
        else: seq.append(dict(k=k, first=t, clicks=1, group=x['channel_group'], ad=x['ad_name'] or '', page=x['page_path'] or ''))
    for i, s in enumerate(seq):
        P.append(dict(order_id=oid, step=i + 1, steps=len(seq), time=s['first'].strftime('%Y-%m-%d %H:%M'), channel=s['k'][0], channel_group=s['group'],
                      campaign_name=s['k'][1], ad_name=s['ad'], landing_page=s['page'], clicks=s['clicks']))
wr('paths.csv', ['order_id', 'step', 'steps', 'time', 'channel', 'channel_group', 'campaign_name', 'ad_name', 'landing_page', 'clicks'], P)
print('sales', len(S), 'funnel', len(F), 'orders', len(O), 'paths', len(P), 'max date', max([r['date'] for r in S + F] or ['-']))

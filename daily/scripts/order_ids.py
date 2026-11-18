"""打印未取消订单的 order_id 列表，供 d4_paths.sql / d5_survey.sql 的 {{ORDER_IDS}} 使用。用法：python3 order_ids.py raw_items.csv"""
import csv, sys
ids = sorted({r['order_id'] for r in csv.DictReader(open(sys.argv[1])) if r['if_cannel'] == '未取消'})
print(','.join("'%s'" % i for i in ids))

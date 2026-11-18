"""生成独立网页 daily/index.html（内嵌数据快照）。用法：python3 make_standalone.py <daily 目录>"""
import os, sys
D = sys.argv[1]
head = open(os.path.join(D, 'scripts/template_head.html')).read()
ids = ['sales', 'funnel', 'orders', 'paths']
csvs = ''.join('<script type="text/csv" id="csv-%s">\n%s\n</script>\n' % (k, open(os.path.join(D, 'data', k + '.csv')).read().rstrip('\n')) for k in ids)
load = '<script>\n["sales", "funnel", "orders", "paths"].forEach((id) => dash.load(id, document.getElementById(\'csv-\' + id).textContent));\n</script>\n'
page = '\n'.join(open(os.path.join(D, 'dashboard/index.html')).read().split('\n')[1:])
open(os.path.join(D, 'index.html'), 'w').write(head + '<div id="dash-root">\n' + csvs + load + page + '\n</div>\n<script>dash.boot();</script>\n</body>\n</html>\n')
print('ok')

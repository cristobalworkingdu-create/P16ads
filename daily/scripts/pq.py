import json,csv,sys
src,out=sys.argv[1],sys.argv[2]
t=open(src).read()
if t.lstrip().startswith('['): t=json.loads(t)[0]['text']
d=json.loads(t); names=[c['name'] for c in d['schema']['fields']]; keep=[i for i,n in enumerate(names) if n!='_pad']
rows=[[r['f'][i]['v'] for i in keep] for r in d.get('rows',[])]
w=csv.writer(open(out,'w',newline='')); w.writerow([names[i] for i in keep]); w.writerows(rows)
print(out,len(rows),d.get('totalRows'))

"""Offline image artifact checks. No live configuration, credentials or network."""
import importlib.metadata,json,pathlib,re,subprocess

packages={}
for line in subprocess.check_output(['apk','info','-vv'],text=True).splitlines():
    match=re.match(r'^(.*)-([0-9][^-]*-r[0-9]+) - ',line)
    if match:packages[match[1]]=match[2]
pins=pathlib.Path('/usr/local/share/rtho-swag/alpine-packages.lock').read_text().splitlines()
for pin in pins:
    name,version=pin.split('=',1);assert packages.get(name)==version,'Installed APK pin mismatch: '+name
assert packages['nginx']==packages['nginx-mod-http-naxsi'],'NGINX/NAXSI ABI mismatch'
assert packages['curl'].startswith('8.23.') and packages['libcurl']==packages['curl'],'Required curl baseline missing'
modules=[]
for path in pathlib.Path('/etc/nginx/modules').glob('*.conf'):
    modules.extend(pathlib.Path(x.strip('"')).name for x in re.findall(r'^\s*load_module\s+([^;]+);',path.read_text(),re.M))
assert len(modules)==3 and set(modules)=={'ndk_http_module.so','ngx_http_naxsi_module.so','ngx_http_set_misc_module.so'},'Unexpected module profile'
for name in ['certbot','acme','certbot-dns-cloudflare']:assert importlib.metadata.version(name)=='5.9.0','Unexpected certificate component: '+name
print(json.dumps({'passed':True,'apk_pins_verified':len(pins),'nginx_naxsi_abi_matches':True,'curl_baseline':'8.23','dynamic_modules':sorted(modules),'certbot_components':'5.9.0'}))

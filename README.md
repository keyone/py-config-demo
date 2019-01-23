# Python OpenShift External configs.

#### Commands to start the application locally
```
git clone https://github.com/keyone/py-config-demo.git
cd py-config-demo
python3 -m virtualenv env
source env/bin/activate
pip install -r requirements.txt
python server.py
```
Then go to http://0.0.0.0:5000/ and if you change the value in hello.ini, it will change in the browser.
We also have a health endpoint at http://0.0.0.0:5000/api/health.

#### Commands to start the application locally but with Docker
```
git clone https://github.com/keyone/py-config-demo.git
cd py-config-demo
docker build -t py-config-demo:v1 .
docker run -it -p 5000:5000 -v $(pwd)/config:/app/config py-config-demo:v1
```

#### Commands to run on OpenShift:
Login to your OC CLI with enough privileges.

```
oc new-project py-config-demo --display-name="Python ConfigMap Demo" --description="Demo of a ConfigMap with a Python 3 Flask application."
oc new-build --binary --name=py-config-demo -l app=py-config-demo
oc start-build py-config-demo --from-dir=. --follow
oc new-app py-config-demo -l app=py-config-demo
oc expose svc/py-config-demo
oc set probe dc/py-config-demo --readiness --get-url=http://:5000/api/health
oc create configmap py-config --from-file=config/hello.ini
oc patch dc/py-config-demo -p '{"spec":{"template":{"spec":{"containers":[{"name":"py-config-demo","volumeMounts":[{"name":"config-volume","mountPath":"/app/config"}]}],"volumes":[{"name":"config-volume","configMap":{"name":"py-config"}}]}}}}'
```

To demo:

`watch oc get pods`

`watch oc exec -it $(pod_id) cat /app/config/hello.ini`

`oc get routes`

`watch curl -s http://$(route)/`

While watching do a change in the ConfigMap

`oc edit cm py-config`

No need to restart the application and the new config take effect.

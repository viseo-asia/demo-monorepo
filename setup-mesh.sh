https://istio.io/docs/setup/kubernetes/install/kubernetes/
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.1.1 sh -
export PATH="$PATH:/Users/viseo/Documents/Viseo/workspace/demo-monorepo/istio-1.1.1/bin"
cd istio-1.1.1/
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
kubectl create namespace dev-env
kubectl label namespace dev-env istio-injection=enabled

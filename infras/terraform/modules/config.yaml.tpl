nameOverride: argocd
global:
  domain: ${ARGO_URL}
crds:
  install: true
  keep: true
server:
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    tls: true
  extraArgs:
  - --insecure
notifications:
  enabled: false
configs:
  cm:
    create: true
    exec.enabled: true
    timeout.reconciliation: 60s
    dex.config: >
      connectors:
        - type: github
          id: github
          name: GitHub
          config:
            clientID: ${GH_CLIENT_ID}
            clientSecret: ${GH_CLIENT_SECRET}
          orgs:
            - name: DevOps-Corner
    url: https://${ARGO_URL}
  rbac:
    policy.csv: |
      g, haidv.ict@gmail.com, role:admin
    policy.default: role:readonly
  secret:
    createSecret: true
    githubSecret: ${GH_SECRET}
  repositories:
    private-repo:
      url: ${REPO_URL}
      password: ${GH_TOKEN}
      username: ${GH_USERNAME}

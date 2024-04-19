apiVersion: v1
data:
  password: ${GH_TOKEN_B64}
  username: ${GH_USERNAME_B64}
kind: Secret
metadata:
  name: git-creds
  namespace: argocd
type: Opaque
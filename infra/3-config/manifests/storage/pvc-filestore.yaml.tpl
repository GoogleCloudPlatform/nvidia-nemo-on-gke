kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: cluster-filestore
  namespace: default
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: cluster-filestore
  resources:
    requests:
      storage: ${NFS_SIZE}

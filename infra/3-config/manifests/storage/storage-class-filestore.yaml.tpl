kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: cluster-filestore
provisioner: filestore.csi.storage.gke.io
volumeBindingMode: Immediate
allowVolumeExpansion: true
parameters:
  tier: ${TIER}
  network: ${PREFIX}

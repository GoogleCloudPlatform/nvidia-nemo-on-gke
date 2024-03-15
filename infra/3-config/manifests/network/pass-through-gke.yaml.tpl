#  Copyright 2024 Google LLC

#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at

#       https://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


apiVersion: networking.gke.io/v1
kind: GKENetworkParamSet
metadata:
  name: ${GKE_NETWORK_NAME}
spec:
  vpc: ${CLUSTER_VPC_NETWORK}
  vpcSubnet: ${CLUSTER_VPC_SUBNET}
  deviceMode: NetDevice

# ---
# apiVersion: networking.gke.io/v1
# kind: GKENetworkParamSet
# metadata:
#   name: vpc2
# spec:
#   vpc: $TF_VAR_PREFIX-gpu-1
#   vpcSubnet: $TF_VAR_PREFIX-gpu-1
#   deviceMode: NetDevice
# ---
# apiVersion: networking.gke.io/v1
# kind: GKENetworkParamSet
# metadata:
#   name: vpc3
# spec:
#   vpc: $TF_VAR_PREFIX-gpu-2
#   vpcSubnet: $TF_VAR_PREFIX-gpu-2
#   deviceMode: NetDevice
# ---
# apiVersion: networking.gke.io/v1
# kind: GKENetworkParamSet
# metadata:
#   name: vpc4
# spec:
#   vpc: $TF_VAR_PREFIX-gpu-3
#   vpcSubnet: $TF_VAR_PREFIX-gpu-3
#   deviceMode: NetDevice


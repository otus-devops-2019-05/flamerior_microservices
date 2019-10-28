#!/bin/bash

kubectl get componentstatuses
kubectl get nodes

kubectl run busybox --image=busybox:1.28 --command -- sleep 3600
kubectl get pods -l run=busybox
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

kubectl get all

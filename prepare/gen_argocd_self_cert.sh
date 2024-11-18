#!/bin/bash -eux

# gen argocd self cert
kubectl create ns argocd
openssl genrsa -out tls.key 2048
openssl req -new -x509 -key tls.key -out tls.crt -days 365 -subj "/CN=argocd.example.com"
kubectl create secret tls argocd-testsecret -n argocd --cert=tls.crt --key=tls.key
rm -f tls.key tls.crt

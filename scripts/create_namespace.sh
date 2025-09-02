#!/bin/bash

# USAGE: ./create_namespace.sh dev

NAMESPACE=$1

if kubectl get namespace "$NAMESPACE" &>/dev/null; then
 echo "  Namespace '$NAMESPACE' already exists..."
else
 kubectl create namespace "$NAMESPACE"
 echo "  Namespace '$NAMESPACE' created successfully!"
fi

#!/bin/bash

NAMESPACE=iden-uat  # <-- Change this
BATCH_SIZE=20
SLEEP_SECONDS=30

# Get original pod names once
ORIGINAL_PODS=$(kubectl get pods -n $NAMESPACE --no-headers | awk '{print $1}')

# Convert to array
readarray -t POD_ARRAY <<<"$ORIGINAL_PODS"

TOTAL=${#POD_ARRAY[@]}
INDEX=0

while [ $INDEX -lt $TOTAL ]; do
  BATCH=("${POD_ARRAY[@]:$INDEX:$BATCH_SIZE}")

  echo "Deleting batch: ${BATCH[*]}"
  printf "%s\n" "${BATCH[@]}" | xargs kubectl delete pod -n $NAMESPACE

  INDEX=$((INDEX + BATCH_SIZE))
  echo "Sleeping $SLEEP_SECONDS seconds before next batch..."
  sleep $SLEEP_SECONDS
done

echo "All original pods deleted."


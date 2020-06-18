#!/bin/bash
DEEXD="/usr/local/bin/witness_node"

# For blockchain download
VERSION=`cat /etc/deex/version`

## Supported Environmental Variables
#
#   * $DEEXD_SEED_NODES
#   * $DEEXD_RPC_ENDPOINT
#   * $DEEXD_PLUGINS
#   * $DEEXD_REPLAY
#   * $DEEXD_RESYNC
#   * $DEEXD_P2P_ENDPOINT
#   * $DEEXD_WITNESS_ID
#   * $DEEXD_PRIVATE_KEY
#   * $DEEXD_TRACK_ACCOUNTS
#   * $DEEXD_PARTIAL_OPERATIONS
#   * $DEEXD_MAX_OPS_PER_ACCOUNT
#   * $DEEXD_ES_NODE_URL
#   * $DEEXD_TRUSTED_NODE
#

ARGS=""
# Translate environmental variables
if [[ ! -z "$DEEXD_SEED_NODES" ]]; then
    for NODE in $DEEXD_SEED_NODES ; do
        ARGS+=" --seed-node=$NODE"
    done
fi
if [[ ! -z "$DEEXD_RPC_ENDPOINT" ]]; then
    ARGS+=" --rpc-endpoint=${DEEXD_RPC_ENDPOINT}"
fi

if [[ ! -z "$DEEXD_REPLAY" ]]; then
    ARGS+=" --replay-blockchain"
fi

if [[ ! -z "$DEEXD_RESYNC" ]]; then
    ARGS+=" --resync-blockchain"
fi

if [[ ! -z "$DEEXD_P2P_ENDPOINT" ]]; then
    ARGS+=" --p2p-endpoint=${DEEXD_P2P_ENDPOINT}"
fi

if [[ ! -z "$DEEXD_WITNESS_ID" ]]; then
    ARGS+=" --witness-id=$DEEXD_WITNESS_ID"
fi

if [[ ! -z "$DEEXD_PRIVATE_KEY" ]]; then
    ARGS+=" --private-key=$DEEXD_PRIVATE_KEY"
fi

if [[ ! -z "$DEEXD_TRACK_ACCOUNTS" ]]; then
    for ACCOUNT in $DEEXD_TRACK_ACCOUNTS ; do
        ARGS+=" --track-account=$ACCOUNT"
    done
fi

if [[ ! -z "$DEEXD_PARTIAL_OPERATIONS" ]]; then
    ARGS+=" --partial-operations=${DEEXD_PARTIAL_OPERATIONS}"
fi

if [[ ! -z "$DEEXD_MAX_OPS_PER_ACCOUNT" ]]; then
    ARGS+=" --max-ops-per-account=${DEEXD_MAX_OPS_PER_ACCOUNT}"
fi

if [[ ! -z "$DEEXD_ES_NODE_URL" ]]; then
    ARGS+=" --elasticsearch-node-url=${DEEXD_ES_NODE_URL}"
fi

if [[ ! -z "$DEEXD_TRUSTED_NODE" ]]; then
    ARGS+=" --trusted-node=${DEEXD_TRUSTED_NODE}"
fi

## Link the deex config file into home
## This link has been created in Dockerfile, already
ln -f -s /etc/deex/config.ini /var/lib/deex

# Plugins need to be provided in a space-separated list, which
# makes it necessary to write it like this
if [[ ! -z "$DEEXD_PLUGINS" ]]; then
   exec $DEEXD --data-dir ${HOME} ${ARGS} ${DEEXD_ARGS} --plugins "${DEEXD_PLUGINS}"
else
   exec $DEEXD --data-dir ${HOME} ${ARGS} ${DEEXD_ARGS}
fi

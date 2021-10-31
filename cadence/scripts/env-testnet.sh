flow_wrap() {
  echo "TESTNET>> flow $*"
  flow "$@"
}

. testnet-keys

FLOW="flow_wrap -f flow-testnet.json -n testnet"
TX="$FLOW transactions send --gas-limit 9999 --signer"
TXS="$TX service"
SC="$FLOW scripts execute"

SERVICE=$SERVICE_ADDRESS
ALICE=$ALICE_ADDRESS
BOB=$BOB_ADDRESS
EVE=$EVE_ADDRESS

service=service
alice=alice
bob=bob
eve=eve

CONTRACT=ebf4ae01d1284af8

royalty() {
    echo '{"type":"Struct","value":{"id":"A.'"$CONTRACT"'.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"'"$1"'"}},{"name":"fee","value":{"type":"UFix64","value":"'"$2"'"}}]}}'
    }

metadata() {
    echo '{"type":"String","value":"'"$1"'"}'
  }


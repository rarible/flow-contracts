flow_wrap() {
  echo "TESTNET>> flow $*"
  flow "$@"
}

#. mainnet-keys

FLOW="flow_wrap -f flow-mainnet.json -n mainnet"
#TX="$FLOW transactions send --gas-limit 9999 --signer"
TX="$FLOW transactions send --signer"
TXS="$TX service"
SC="$FLOW scripts execute"

SERVICE=0x01ab36aaf654a13e
#ALICE=$ALICE_ADDRESS
#BOB=$BOB_ADDRESS
#EVE=$EVE_ADDRESS

service=service
#alice=alice
#bob=bob
#eve=eve

CONTRACT=01ab36aaf654a13e

royalty() {
    echo '{"type":"Struct","value":{"id":"A.'"$CONTRACT"'.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"'"$1"'"}},{"name":"fee","value":{"type":"UFix64","value":"'"$2"'"}}]}}'
    }

metadata() {
    echo '{"type":"String","value":"'"$1"'"}'
  }


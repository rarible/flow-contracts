flow_wrap() {
  echo "EMULATOR>> flow $*"
  flow "$@"
}

FLOW="flow_wrap -f flow-emulator.json -n emulator"
TX="$FLOW transactions send --gas-limit 9999 --signer"
TXS="$TX emulator-account"
SC="$FLOW scripts execute"

SERVICE=0xf8d6e0586b0a20c7
ALICE=0x01cf0e2f2f715450
BOB=0x179b6b1cb6755e31
EVE=0xf3fcd2c1a78f5eee

service=service
alice=alice
bob=bob
eve=eve

CONTRACT=f8d6e0586b0a20c7

royalty() {
    echo '{"type":"Struct","value":{"id":"A.'"$CONTRACT"'.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"'"$1"'"}},{"name":"fee","value":{"type":"UFix64","value":"'"$2"'"}}]}}'
    }

metadata() {
    echo '{"type":"String","value":"'"$1"'"}'
  }


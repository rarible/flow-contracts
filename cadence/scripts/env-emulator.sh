flow_wrap() {
  echo "EMULATOR>> flow $*"
  flow "$@"
}

FLOW=flow_wrap
TX="$FLOW transactions send --gas-limit 10000 --signer"
TXS="$TX emulator-account"
SC="$FLOW scripts execute"

CONTRACT=f8d6e0586b0a20c7

SERVICE=0xf8d6e0586b0a20c7
ALICE=0x01cf0e2f2f715450
BOB=0x179b6b1cb6755e31
EVE=0xf3fcd2c1a78f5eee

service=emulator-account
alice=emulator-alice
bob=emulator-bob
eve=emulator-eve

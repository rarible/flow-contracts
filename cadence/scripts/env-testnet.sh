flow_wrap() {
  echo "TESTNET>> flow $*"
  flow "$@"
}

FLOW="flow_wrap -n testnet"
TX="$FLOW transactions send --gas-limit 9999 --signer"
TXS="$TX service"
SC="$FLOW scripts execute"

SERVICE=0xebf4ae01d1284af8
ALICE=0xf35651751cf88582
BOB=0xf87c63ecd07dfbab
EVE=0x0a4fbf025883f115

service=service
alice=alice
bob=bob
eve=eve

CONTRACT=01658d9b94068f3c

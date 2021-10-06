#!/usr/bin/env bash
. env.sh

$TXS transactions/commonNft/mint.cdc --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0x179b6b1cb6755e31"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0xf3fcd2c1a78f5eee"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'
$TXS transactions/commonNft/mint.cdc --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0x179b6b1cb6755e31"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0xf3fcd2c1a78f5eee"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'

$TX $alice transactions/commonNft/mint.cdc --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0x179b6b1cb6755e31"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.CommonNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0xf3fcd2c1a78f5eee"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'

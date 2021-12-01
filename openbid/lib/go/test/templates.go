package test

import (
	"github.com/onflow/flow-go-sdk"
)

const (
	RaribleOpenBidRaribleOpenBidPath     = "../../../contracts/RaribleOpenBid.cdc"
	RaribleOpenBidRootPath              = "../../../transactions"
	RaribleOpenBidSetupAccountPath      = RaribleOpenBidRootPath + "/setup_account.cdc"
	RaribleOpenBidSellItemPath          = RaribleOpenBidRootPath + "/open_bid.cdc"
	RaribleOpenBidBuyItemPath           = RaribleOpenBidRootPath + "/close_bid.cdc"
	RaribleOpenBidRemoveItemPath        = RaribleOpenBidRootPath + "/remove_bid.cdc"
	RaribleOpenBidGetIDsPath            = RaribleOpenBidRootPath + "/scripts/read_OpenBid_ids.cdc"
	RaribleOpenBidGetBidDetailsPath = RaribleOpenBidRootPath + "/scripts/read_Bid_details.cdc"
)

func replaceAddresses(codeBytes []byte, contracts Contracts) []byte {
	code := string(codeBytes)

	code = ftAddressPlaceholder.ReplaceAllString(code, "0x"+ftAddress.String())
	code = flowTokenAddressPlaceHolder.ReplaceAllString(code, "0x"+flowTokenAddress.String())
	code = nftAddressPlaceholder.ReplaceAllString(code, "0x"+contracts.NFTAddress.String())
	code = exampleNFTAddressPlaceHolder.ReplaceAllString(code, "0x"+contracts.ExampleNFTAddress.String())
	code = RaribleOpenBidAddressPlaceholder.ReplaceAllString(code, "0x"+contracts.RaribleOpenBidAddress.String())

	return []byte(code)
}

func loadRaribleOpenBid(ftAddr, nftAddr flow.Address) []byte {
	code := string(readFile(RaribleOpenBidRaribleOpenBidPath))

	code = ftAddressPlaceholder.ReplaceAllString(code, "0x"+ftAddr.String())
	code = nftAddressPlaceholder.ReplaceAllString(code, "0x"+nftAddr.String())

	return []byte(code)
}

func RaribleOpenBidGenerateSetupAccountScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidSetupAccountPath),
		contracts,
	)
}

func RaribleOpenBidGenerateSellItemScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidSellItemPath),
		contracts,
	)
}

func RaribleOpenBidGenerateBuyItemScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidBuyItemPath),
		contracts,
	)
}

func RaribleOpenBidGenerateRemoveItemScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidRemoveItemPath),
		contracts,
	)
}

func RaribleOpenBidGenerateGetIDsScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidGetIDsPath),
		contracts,
	)
}

func RaribleOpenBidGenerateGetBidDetailsScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(RaribleOpenBidGetBidDetailsPath),
		contracts,
	)
}

package test

import (
	"github.com/onflow/flow-go-sdk"
)

const (
	EnglishAuctionEnglishAuctionPath    = "../../../contracts/EnglishAuction.cdc"
	EnglishAuctionRootPath              = "../../../transactions"
	EnglishAuctionAddLotPath            = EnglishAuctionRootPath + "/add_lot.cdc"
	EnglishAuctionCancelLotPath         = EnglishAuctionRootPath + "/cancel_lot.cdc"
	EnglishAuctionCompleteLotPath       = EnglishAuctionRootPath + "/complete_lot.cdc"
	EnglishAuctionAddBidPath            = EnglishAuctionRootPath + "/add_bid.cdc"
	EnglishAuctionGetIDsPath            = EnglishAuctionRootPath + "/scripts/get_ids.cdc"
	EnglishAuctionBorrowLotPath         = EnglishAuctionRootPath + "/scripts/borrow_lot.cdc"
)

func replaceAddresses(codeBytes []byte, contracts Contracts) []byte {
	code := string(codeBytes)

	code = ftAddressPlaceholder.ReplaceAllString(code, "0x"+ftAddress.String())
	code = flowTokenAddressPlaceHolder.ReplaceAllString(code, "0x"+flowTokenAddress.String())
	code = nftAddressPlaceholder.ReplaceAllString(code, "0x"+contracts.NFTAddress.String())
	code = exampleNFTAddressPlaceHolder.ReplaceAllString(code, "0x"+contracts.ExampleNFTAddress.String())
	code = EnglishAuctionAddressPlaceholder.ReplaceAllString(code, "0x"+contracts.EnglishAuctionAddress.String())

	return []byte(code)
}

func loadEnglishAuction(ftAddr, nftAddr flow.Address) []byte {
	code := string(readFile(EnglishAuctionEnglishAuctionPath))

	code = ftAddressPlaceholder.ReplaceAllString(code, "0x"+ftAddr.String())
	code = nftAddressPlaceholder.ReplaceAllString(code, "0x"+nftAddr.String())

	return []byte(code)
}

func EnglishAuctionGenerateAddLotScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionAddLotPath),
		contracts,
	)
}

func EnglishAuctionGenerateCancelLotScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionCancelLotPath),
		contracts,
	)
}

func EnglishAuctionGenerateCompleteLotScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionCompleteLotPath),
		contracts,
	)
}

func EnglishAuctionGenerateAddBidScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionAddBidPath),
		contracts,
	)
}

func EnglishAuctionGenerateBorrowLotScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionBorrowLotPath),
		contracts,
	)
}

func EnglishAuctionGenerateGetIDsScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(EnglishAuctionGetIDsPath),
		contracts,
	)
}

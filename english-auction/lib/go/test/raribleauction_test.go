package test

// go test -timeout 30s . -run ^TestEnglishAuction -v

import (
	"fmt"
	"testing"
)

func TestEnglishAuctionDeployContracts(t *testing.T) {
	b := newEmulator()
	EnglishAuctionDeployContracts(t, b)
}

func TestEnglishAuctionAddLot(t *testing.T) {
	b := newEmulator()

	contracts := EnglishAuctionDeployContracts(t, b)

	aliceAddress, aliceSigner := createAccount(t, b)
	setupAccount(t, b, aliceAddress, aliceSigner, contracts)
	bobAddress, bobSigner := createAccount(t, b)
	setupAccount(t, b, bobAddress, bobSigner, contracts)

	mintExampleNFT(t, b, aliceAddress,
		contracts.NFTAddress,
		contracts.ExampleNFTAddress,
		contracts.ExampleNFTSigner,
	)
	var lotId = EnglishAuctionAddLot(t, b, contracts, aliceAddress, aliceSigner, 0)
	fmt.Println(lotId)
	borrowLot(t, b, contracts, lotId)
	EnglishAuctionCancelLot(t, b, contracts, bobAddress, bobSigner, lotId, true)
	EnglishAuctionCancelLot(t, b, contracts, aliceAddress, aliceSigner, lotId, false)
}

func TestEnglishAuctionAddBidScript(t *testing.T) {
	b := newEmulator()
	contracts := EnglishAuctionDeployContracts(t, b)

	aliceAddress, aliceSigner := createAccount(t, b)
	setupAccount(t, b, aliceAddress, aliceSigner, contracts)
	bobAddress, bobSigner := createAccount(t, b)
	setupAccount(t, b, bobAddress, bobSigner, contracts)
	eveAddress, eveSigner := createAccount(t, b)
	setupAccount(t, b, eveAddress, eveSigner, contracts)

	t.Run("Bid handling", func(t *testing.T) {
		mintExampleNFT(t, b, aliceAddress,
			contracts.NFTAddress,
			contracts.ExampleNFTAddress,
			contracts.ExampleNFTSigner,
		)

		var lotId = EnglishAuctionAddLot(t, b, contracts, aliceAddress, aliceSigner, 0)

		// Bob adds bid
		EnglishAuctionAddBid(t, b, contracts, bobAddress, bobSigner, lotId, "0.11", false)
		// Bob can't bid again
		EnglishAuctionAddBid(t, b, contracts, bobAddress, bobSigner, lotId, "0.12", true)
		//
		EnglishAuctionAddBid(t, b, contracts, eveAddress, eveSigner, lotId, "0.11", true)
		// Eve outbid Bob
		EnglishAuctionAddBid(t, b, contracts, eveAddress, eveSigner, lotId, "0.15", false)

		EnglishAuctionCompleteLot(t, b, contracts, aliceAddress, aliceSigner, lotId, true)
		//borrowLot(t, b, contracts, lotId)
	})

	t.Run("Should be able to add bid", func(t *testing.T) {
		mintExampleNFT(t, b, aliceAddress,
			contracts.NFTAddress,
			contracts.ExampleNFTAddress,
			contracts.ExampleNFTSigner,
		)

		var lotId = EnglishAuctionAddLot(t, b, contracts, aliceAddress, aliceSigner, 1)
		EnglishAuctionCompleteLot(t, b, contracts, aliceAddress, aliceSigner, lotId, true)

		EnglishAuctionAddBid(t, b, contracts, bobAddress, bobSigner, lotId, "0.11", false)
		// buyout price
		EnglishAuctionAddBid(t, b, contracts, eveAddress, eveSigner, lotId, "11.11", false)
	})
}

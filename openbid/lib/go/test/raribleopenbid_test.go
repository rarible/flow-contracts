package test

// go test -timeout 30s . -run ^TestRaribleOpenBid -v

import (
	"testing"
)

func TestRaribleOpenBidDeployContracts(t *testing.T) {
	b := newEmulator()
	RaribleOpenBidDeployContracts(t, b)
}

func TestRaribleOpenBidSetupAccount(t *testing.T) {
	b := newEmulator()

	contracts := RaribleOpenBidDeployContracts(t, b)

	userAddress, userSigner := createAccount(t, b)
	setupRaribleOpenBid(t, b, userAddress, userSigner, contracts)
}

func TestRaribleOpenBidCreateSaleSell(t *testing.T) {
	b := newEmulator()

	contracts := RaribleOpenBidDeployContracts(t, b)

	t.Run("Should be able to open bid", func(t *testing.T) {
		tokenToList := uint64(0)
		tokenPrice := "1.11"

		bidderAddress, bidderSigner := createAccount(t, b)
		setupAccount(t, b, bidderAddress, bidderSigner, contracts)

		// Contract mints item to seller account
		mintExampleNFT(t, b,
			bidderAddress,
			contracts.NFTAddress,
			contracts.ExampleNFTAddress,
			contracts.ExampleNFTSigner,
		)

		// Seller account lists the item
		openBid(t, b,
			contracts,
			bidderAddress,
			bidderSigner,
			tokenToList,
			tokenPrice,
			false,
		)
	})

	t.Run("Should be able to close bid", func(t *testing.T) {
		tokenToList := uint64(1)
		tokenPrice := "1.11"

		sellerAddress, sellerSigner := createAccount(t, b)
		setupAccount(t, b, sellerAddress, sellerSigner, contracts)

		BidResourceID := openBid(t, b,
			contracts,
			sellerAddress,
			sellerSigner,
			tokenToList,
			tokenPrice,
			false,
		)

		buyerAddress, buyerSigner := createAccount(t, b)
		setupAccount(t, b, buyerAddress, buyerSigner, contracts)

		mintExampleNFT(t, b,
			buyerAddress,
			contracts.NFTAddress,
			contracts.ExampleNFTAddress,
			contracts.ExampleNFTSigner,
		)

		closeBid(b, t,
			contracts,
			buyerAddress,
			buyerSigner,
			sellerAddress,
			BidResourceID,
			false,
		)
	})

	t.Run("Should be able to remove bid", func(t *testing.T) {
		tokenToList := uint64(2)
		tokenPrice := "1.11"

		sellerAddress, sellerSigner := createAccount(t, b)
		setupAccount(t, b, sellerAddress, sellerSigner, contracts)

		// Contract mints item to seller account
		mintExampleNFT(
			t,
			b,
			sellerAddress,
			contracts.NFTAddress,
			contracts.ExampleNFTAddress,
			contracts.ExampleNFTSigner,
		)

		// Seller account lists the item
		BidResourceID := openBid(
			t,
			b,
			contracts,
			sellerAddress,
			sellerSigner,
			tokenToList,
			tokenPrice,
			false,
		)

		// Cancel the sale
		removeBid(
			b,
			t,
			contracts,
			sellerAddress,
			sellerSigner,
			BidResourceID,
			false,
		)
	})
}

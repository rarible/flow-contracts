package test

import (
	"fmt"
	"testing"

	"github.com/onflow/cadence"
	emulator "github.com/onflow/flow-emulator"
	fttemplates "github.com/onflow/flow-ft/lib/go/templates"
	"github.com/onflow/flow-go-sdk"
	sdk "github.com/onflow/flow-go-sdk"
	"github.com/onflow/flow-go-sdk/crypto"
	nfttemplates "github.com/onflow/flow-nft/lib/go/templates"
)

func setupExampleNFTCollection(
	t *testing.T,
	b *emulator.Blockchain,
	userAddress flow.Address,
	userSigner crypto.Signer,
	nftAddress, exampleNFTAddress flow.Address,
) {
	script := nfttemplates.GenerateCreateCollectionScript(
		nftAddress.String(),
		exampleNFTAddress.String(),
		"ExampleNFT",
		"exampleNFTCollection",
	)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(userAddress)

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address, userAddress},
		[]crypto.Signer{b.ServiceKey().Signer(), userSigner},
		false,
	)
}

func mintExampleNFT(
	t *testing.T,
	b *emulator.Blockchain,
	receiverAddress flow.Address,
	nftAddress, exampleNFTAddress flow.Address,
	exampleNFTSigner crypto.Signer,
) {
	script := nfttemplates.GenerateMintNFTScript(nftAddress, exampleNFTAddress, receiverAddress)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(exampleNFTAddress)

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address, exampleNFTAddress},
		[]crypto.Signer{b.ServiceKey().Signer(), exampleNFTSigner},
		false,
	)
}

func fundAccount(
	t *testing.T,
	b *emulator.Blockchain,
	receiverAddress flow.Address,
	amount string,
) {
	script := fttemplates.GenerateMintTokensScript(
		ftAddress,
		flowTokenAddress,
		flowTokenName,
	)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(b.ServiceKey().Address)

	tx.AddArgument(cadence.NewAddress(receiverAddress))
	tx.AddArgument(cadenceUFix64(amount))

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address},
		[]crypto.Signer{b.ServiceKey().Signer()},
		false,
	)
}

func openBid(
	t *testing.T,
	b *emulator.Blockchain,
	contracts Contracts,
	userAddress sdk.Address,
	userSigner crypto.Signer,
	tokenID uint64,
	price string,
	shouldFail bool,
) uint64 {
	tx := flow.NewTransaction().
		SetScript(RaribleOpenBidGenerateSellItemScript(contracts)).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(userAddress)

	_ = tx.AddArgument(cadence.NewUInt64(tokenID))
	_ = tx.AddArgument(cadenceUFix64(price))

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address, userAddress},
		[]crypto.Signer{b.ServiceKey().Signer(), userSigner},
		shouldFail,
	)

	// Get the most recently created BidAvailable event resource ID
	eventType := fmt.Sprintf("A.%s.RaribleOpenBid.BidAvailable", contracts.RaribleOpenBidAddress.Hex())
	BidResourceID := uint64(0)

	var i uint64
	i = 0
	for i < 1000 {
		results, _ := b.GetEventsByHeight(i, eventType)
		for _, event := range results {
			if event.Type == eventType {
				BidResourceID = event.Value.Fields[0].(cadence.UInt64).ToGoValue().(uint64)
			}
		}
		i = i + 1
	}

	return BidResourceID
}

func closeBid(
	b *emulator.Blockchain,
	t *testing.T,
	contracts Contracts,
	userAddress sdk.Address,
	userSigner crypto.Signer,
	marketCollectionAddress sdk.Address,
	offerResourceID uint64,
	shouldFail bool,
) {
	tx := flow.NewTransaction().
		SetScript(RaribleOpenBidGenerateBuyItemScript(contracts)).
		SetGasLimit(200).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(userAddress)

	_ = tx.AddArgument(cadence.NewUInt64(offerResourceID))
	_ = tx.AddArgument(cadence.NewAddress(marketCollectionAddress))

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address, userAddress},
		[]crypto.Signer{b.ServiceKey().Signer(), userSigner},
		shouldFail,
	)
}

func removeBid(
	b *emulator.Blockchain,
	t *testing.T,
	contracts Contracts,
	userAddress sdk.Address,
	userSigner crypto.Signer,
	offerResourceID uint64,
	shouldFail bool,
) {
	tx := flow.NewTransaction().
		SetScript(RaribleOpenBidGenerateRemoveItemScript(contracts)).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(userAddress)

	_ = tx.AddArgument(cadence.NewUInt64(offerResourceID))

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address, userAddress},
		[]crypto.Signer{b.ServiceKey().Signer(), userSigner},
		shouldFail,
	)
}

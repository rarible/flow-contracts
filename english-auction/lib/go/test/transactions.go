package test

import (
	"fmt"
	"github.com/onflow/cadence/encoding/json"
	"github.com/onflow/flow-emulator/types"
	"strings"
	"testing"

	cadence "github.com/onflow/cadence"
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

func EnglishAuctionAddLot(t *testing.T, b *emulator.Blockchain, contracts Contracts, address sdk.Address, signer crypto.Signer, tokenId uint64) uint64 {
	script := EnglishAuctionGenerateAddLotScript(contracts)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(address)

	//_ = tx.AddArgument(cadence.NewAddress(contracts.EnglishAuctionAddress))
	_ = tx.AddArgument(cadence.NewUInt64(tokenId)) // tokenId
	_ = tx.AddArgument(cadenceUFix64("0.1"))       // minimum bid
	_ = tx.AddArgument(cadenceUFix64("10.0"))      // buyout price
	_ = tx.AddArgument(cadenceUFix64("0.01"))      // increment
	_ = tx.AddArgument(cadenceUFix64("0.0"))       // startAt
	_ = tx.AddArgument(cadenceUFix64("2.0"))       // duration
	_ = tx.AddArgument(cadence.NewDictionary([]cadence.KeyValuePair{
		{Key: cadence.NewAddress(contracts.EnglishAuctionAddress), Value: cadenceUFix64("0.05")},
	}))

	traceTxResult(signAndSubmit(t, b, tx,
		[]flow.Address{b.ServiceKey().Address, address},
		[]crypto.Signer{b.ServiceKey().Signer(), signer},
		false,
	), "AddLot")

	eventType := fmt.Sprintf("A.%s.EnglishAuction.LotAvailable", contracts.EnglishAuctionAddress.Hex())
	lotId := uint64(0)

	var i uint64
	i = 0
	for i < 1000 {
		results, _ := b.GetEventsByHeight(i, eventType)
		//n,_ := b.GetBlockByHeight(i)
		//println(n.Header.Timestamp.String())
		for _, event := range results {
			//fmt.Println(event.Value)
			if event.Type == eventType {
				//fmt.Println(event.Value)
				lotId = event.Value.Fields[0].(cadence.UInt64).ToGoValue().(uint64)
			}
		}
		i = i + 1
	}

	return lotId
}

func EnglishAuctionCancelLot(t *testing.T, b *emulator.Blockchain, contracts Contracts, address sdk.Address, signer crypto.Signer, lotId uint64, shouldRevert bool) {
	script := EnglishAuctionGenerateCancelLotScript(contracts)

	b.PendingBlockTimestamp()

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(100).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(address)

	_ = tx.AddArgument(cadence.NewUInt64(lotId))

	traceTxResult(signAndSubmit(t, b, tx,
		[]flow.Address{b.ServiceKey().Address, address},
		[]crypto.Signer{b.ServiceKey().Signer(), signer},
		shouldRevert,
	), "CancelLot")
}

func EnglishAuctionCompleteLot(t *testing.T, b *emulator.Blockchain, contracts Contracts, address sdk.Address, signer crypto.Signer, lotId uint64, shouldRevert bool) {
	script := EnglishAuctionGenerateCompleteLotScript(contracts)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(200).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(address)

	_ = tx.AddArgument(cadence.NewUInt64(lotId))

	result := signAndSubmit(t, b, tx,
		[]flow.Address{b.ServiceKey().Address, address},
		[]crypto.Signer{b.ServiceKey().Signer(), signer},
		shouldRevert,
	)

	traceTxResult(result, "CompleteLot")
}

func EnglishAuctionAddBid(t *testing.T, b *emulator.Blockchain, contracts Contracts, address sdk.Address, signer crypto.Signer, lotId uint64, amount string, shouldRevert bool) {
	script := EnglishAuctionGenerateAddBidScript(contracts)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(300).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(address)

	_ = tx.AddArgument(cadence.NewUInt64(lotId))
	_ = tx.AddArgument(cadenceUFix64(amount))
	_ = tx.AddArgument(cadence.NewDictionary([]cadence.KeyValuePair{
		{Key: cadence.NewAddress(contracts.EnglishAuctionAddress), Value: cadenceUFix64("0.05")},
	}))

	result := signAndSubmit(t, b, tx,
		[]flow.Address{b.ServiceKey().Address, address},
		[]crypto.Signer{b.ServiceKey().Signer(), signer},
		shouldRevert,
	)

	traceTxResult(result, "AddBid")
}

func EnglishAuctionIncBid(t *testing.T, b *emulator.Blockchain, contracts Contracts, address sdk.Address, signer crypto.Signer, lotId uint64, amount string, shouldRevert bool) {
	script := EnglishAuctionGenerateIncBidScript(contracts)

	tx := flow.NewTransaction().
		SetScript(script).
		SetGasLimit(300).
		SetProposalKey(b.ServiceKey().Address, b.ServiceKey().Index, b.ServiceKey().SequenceNumber).
		SetPayer(b.ServiceKey().Address).
		AddAuthorizer(address)

	_ = tx.AddArgument(cadence.NewUInt64(lotId))
	_ = tx.AddArgument(cadenceUFix64(amount))

	result := signAndSubmit(t, b, tx,
		[]flow.Address{b.ServiceKey().Address, address},
		[]crypto.Signer{b.ServiceKey().Signer(), signer},
		shouldRevert,
	)

	traceTxResult(result, "IncBid")
}

func traceTxResult(result *types.TransactionResult, s string) {
	fmt.Printf("\nTX:%s: %v\t\n", result.TransactionID, s)
	for _, element := range result.Events {
		fmt.Printf(" %v: %s\n", element.EventIndex, element.Value)
	}
	for _, element := range result.Logs {
		fmt.Printf("    LOG: %s\n", element)
	}
	if result.Reverted() {
		fmt.Printf("    ERR: %s\n", strings.Replace(result.Error.Error(), "\n", "\n    ERR: ", -1))
	}
}

func borrowLot(t *testing.T, b *emulator.Blockchain, contracts Contracts, lotId uint64) cadence.Value {
	script := EnglishAuctionGenerateBorrowLotScript(contracts)

	arg, _ := json.Encode(cadence.NewUInt64(lotId))

	result := executeScriptAndCheck(t, b, script, [][]byte{arg})

	fmt.Printf("\nSC: %s", result)
	return result
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

	_ = tx.AddArgument(cadence.NewAddress(receiverAddress))
	_ = tx.AddArgument(cadenceUFix64(amount))

	signAndSubmit(
		t, b, tx,
		[]flow.Address{b.ServiceKey().Address},
		[]crypto.Signer{b.ServiceKey().Signer()},
		false,
	)

}

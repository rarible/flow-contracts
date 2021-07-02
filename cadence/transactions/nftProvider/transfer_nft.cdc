/**
 * TransferNFT by id from signer to recepient address.
 * Recipient must be a token holder
 *
 * @param address flow account address
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction (id: UInt64, recipientAddress: Address) {
    let receiver: &{NonFungibleToken.CollectionPublic}
    let sender: &AnyResource{NonFungibleToken.Provider}

    prepare(signer: AuthAccount) {
        let recipient = getAccount(recipientAddress)
        self.receiver = recipient.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")

        self.sender = signer.borrow<&AnyResource{NonFungibleToken.Provider}>(from: /storage/NFTCollection)
            ?? panic("Could not borrow sender reference")
    }

    execute {
        let nft <- self.sender.withdraw(withdrawID: id)
        self.receiver.deposit(token: <-nft)
    }
}

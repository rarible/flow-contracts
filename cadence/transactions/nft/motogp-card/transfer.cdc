import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"

// transfer MotoGPCard token with tokenId to given address
//
transaction(tokenId: UInt64, to: Address) {
    let token: @NonFungibleToken.NFT
    let receiver: Capability<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>

    prepare(acct: AuthAccount) {
        let collection = acct.borrow<&MotoGPCard.Collection>(from: /storage/motogpCardCollection)
            ?? panic("Missing NFT collection on signer account")
        self.token <- collection.withdraw(withdrawID: tokenId)
        self.receiver = getAccount(to).getCapability<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection)
    }

    execute {
        let receiver = self.receiver.borrow()!
        receiver.deposit(token: <- self.token)
    }
}
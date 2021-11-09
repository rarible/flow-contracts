import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import TopShot from "../../../contracts/third-party/TopShot.cdc"

// transfer TopShot token with tokenId to given address
//
transaction(tokenId: UInt64, to: Address) {
    let token: @NonFungibleToken.NFT
    let receiver: Capability<&{TopShot.MomentCollectionPublic}>

    prepare(acct: AuthAccount) {
        let collection = acct.borrow<&TopShot.Collection>(from: /storage/MomentCollection)
            ?? panic("Missing NFT collection on signer account")
        self.token <- collection.withdraw(withdrawID: tokenId)
        self.receiver = getAccount(to).getCapability<&{TopShot.MomentCollectionPublic}>(/public/MomentCollection)
    }

    execute {
        let receiver = self.receiver.borrow()!
        receiver.deposit(token: <- self.token)
    }
}
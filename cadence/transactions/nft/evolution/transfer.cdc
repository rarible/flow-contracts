import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import Evolution from "../../../contracts/third-party/Evolution.cdc"

// transfer Evolution token with tokenId to given address
//
transaction(tokenId: UInt64, to: Address) {
    let token: @NonFungibleToken.NFT
    let receiver: Capability<&{Evolution.EvolutionCollectionPublic}>

    prepare(acct: AuthAccount) {
        let collection = acct.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection)
            ?? panic("Missing NFT collection on signer account")
        self.token <- collection.withdraw(withdrawID: tokenId)
        self.receiver = getAccount(to).getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection)
    }

    execute {
        let receiver = self.receiver.borrow()!
        receiver.deposit(token: <- self.token)
    }
}
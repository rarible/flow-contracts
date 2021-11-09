import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../../contracts/third-party/MotoGPCard.cdc"

// check MotoGPCard collection is available on given address
//
pub fun main(address: Address): Bool {
    return getAccount(address)
        .getCapability<&{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection)
        .check()
}

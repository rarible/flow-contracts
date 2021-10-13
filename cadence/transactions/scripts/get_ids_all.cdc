import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"
import Evolution from "../../contracts/third-party/Evolution.cdc"
import MotoGPCard from "../../contracts/third-party/MotoGPCard.cdc"
import TopShot from "../../contracts/third-party/TopShot.cdc"

pub fun idsCommonNFT(_ account: PublicAccount): [UInt64] {
    return account.getCapability(CommonNFT.collectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?.getIDs() ?? []
}

pub fun idsEvolution(_ account: PublicAccount): [UInt64] {
    return account.getCapability(/public/f4264ac8f3256818_Evolution_Collection)
        .borrow<&{Evolution.EvolutionCollectionPublic}>()
        ?.getIDs() ?? []
}

pub fun idsMotoGpCard(_ account: PublicAccount): [UInt64] {
    return account.getCapability(/public/motogpCardCollection)
        .borrow<&{MotoGPCard.ICardCollectionPublic}>()
        ?.getIDs() ?? []
}

pub fun idsTopShot(_ account: PublicAccount): [UInt64] {
    return account.getCapability(/public/MomentCollection)
        .borrow<&{TopShot.MomentCollectionPublic}>()
        ?.getIDs() ?? []
}

pub fun main(address: Address): {String: [UInt64]} {
    let account = getAccount(address)
    let results : {String: [UInt64]} = {}

    results["CommonNFT"] = idsCommonNFT(account)
    results["Evolution"] = idsEvolution(account)
    results["MotoGPCard"] = idsMotoGpCard(account)
    results["TopShot"] = idsTopShot(account)

    return results
}

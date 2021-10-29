import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../contracts/RaribleNFT.cdc"
import Evolution from "../../contracts/third-party/Evolution.cdc"
import MotoGPCard from "../../contracts/third-party/MotoGPCard.cdc"
import TopShot from "../../contracts/third-party/TopShot.cdc"

pub fun idsRaribleNFT(_ account: PublicAccount): [UInt64] {
    return account.getCapability(RaribleNFT.collectionPublicPath)
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

    results["RaribleNFT"] = idsRaribleNFT(account)
    results["Evolution"] = idsEvolution(account)
    results["MotoGPCard"] = idsMotoGpCard(account)
    results["TopShot"] = idsTopShot(account)

    return results
}

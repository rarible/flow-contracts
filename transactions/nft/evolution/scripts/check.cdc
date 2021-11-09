
    import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
    import Evolution from "../../../../contracts/third-party/Evolution.cdc"

    // check Evolution collection is available on given address
    //
    pub fun main(address: Address): Bool {
        return getAccount(address)
            .getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection)
            .check()
    }

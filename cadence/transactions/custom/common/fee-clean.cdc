import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../contracts/RaribleNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        destroy <- account.load<@AnyResource>(from: /storage/commonFeeManager)
    }
}

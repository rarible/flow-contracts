import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../../contracts/CommonNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        destroy <- account.load<@AnyResource>(from: /storage/commonFeeManager)
    }
}

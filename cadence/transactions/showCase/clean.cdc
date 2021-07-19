/**
 * Deinitialize ShowCase account
 * !!! BURNS ALL NFT !!!
 */
import StoreShowCase from "../../contracts/StoreShowCase.cdc"

transaction {
    prepare (signer: AuthAccount) {
        signer.unlink(StoreShowCase.storeShowCasePublicPath)
        let collection <- signer.load<@AnyResource>(from: StoreShowCase.storeShowCaseStoragePath)
        destroy collection
    }
}

/**
 * Initialize showCase on signer account
 */
import StoreShowCase from "../../contracts/StoreShowCase.cdc"

transaction {
    prepare(account: AuthAccount) {
        StoreShowCase.installShowCase(account: account)
    }
}

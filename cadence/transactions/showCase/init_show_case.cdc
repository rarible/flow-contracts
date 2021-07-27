/**
 * Initialize showCase on signer account
 */
import StoreShowCase from 0xSTORESHOWCASE

transaction {
    prepare(account: AuthAccount) {
        StoreShowCase.installShowCase(account: account)
    }
}

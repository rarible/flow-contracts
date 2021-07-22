/**
 * Initialize showCase on signer account
 */
import StoreShowCase from 0xSTORESHOWCASEADDRESS

transaction {
    prepare(account: AuthAccount) {
        StoreShowCase.installShowCase(account: account)
    }
}

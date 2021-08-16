/**
 * Initialize showCase on signer account
 */
import StoreShowCase from 0xSTORESHOWCASE

transaction {
    prepare(account: AuthAccount) {
        if account.borrow<&StoreShowCase.ShowCase>(from: StoreShowCase.storeShowCaseStoragePath) == nil {
            let showCase <- StoreShowCase.createShowCase()
            account.save(<- showCase, to: StoreShowCase.storeShowCaseStoragePath)
            account.link<&{StoreShowCase.ShowCasePublic}>(StoreShowCase.storeShowCasePublicPath, target: StoreShowCase.storeShowCaseStoragePath)
        }
    }
}

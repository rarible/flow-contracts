/**
 * Returns list of sale ids has owned by address
 *
 * @param address flow account address
 */
import StoreShowCase from 0xSTORESHOWCASEADDRESS

pub fun main(address: Address): [UInt64] {
    let account = getAccount(address)
    let sales = account.getCapability<&{StoreShowCase.ShowCasePublic}>(StoreShowCase.storeShowCasePublicPath).borrow()
        ?? panic("Could not borrow reference (maybe account not initialized?)")
    return sales.getIDs()
}

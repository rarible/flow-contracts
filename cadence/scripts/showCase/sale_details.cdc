/**
 * Returns sale details id and address
 *
 * @param id sale identifier
 * @param address flow account address
 */
import StoreShowCase from 0xSTORESHOWCASE
import SaleOrder from 0xSALEORDER

pub fun main(id: UInt64, address: Address): &SaleOrder.Order {
    let account = getAccount(address)
    let collection = account.getCapability<&{StoreShowCase.ShowCasePublic}>(StoreShowCase.storeShowCasePublicPath).borrow()
        ?? panic("Could not borrow reference (maybe account not initialized?)")
    return collection.borrow(id: id)
}

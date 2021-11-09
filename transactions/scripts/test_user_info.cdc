import FungibleToken from "../../contracts/core/FungibleToken.cdc"

pub fun getBalance(_ account: PublicAccount, _ path: PublicPath): UFix64? {
    return account.getCapability(path)
        .borrow<&{FungibleToken.Balance}>()?.balance
        ?? nil
}

pub fun getUserInfo(_ address: Address): {String: AnyStruct} {
    let account = getAccount(address)
    let results: {String: AnyStruct} = {}
    results["flow"] = getBalance(account, /public/flowTokenBalance)
    results["fusd"] = getBalance(account, /public/fusdBalance)
    return results
}

pub fun main(): {String: AnyStruct} {
    let results : {String: AnyStruct} = {}
    results["service"] = getUserInfo(0x01658d9b94068f3c)
    results["alice"] = getUserInfo(0xf35651751cf88582)
    results["bob"] = getUserInfo(0xf87c63ecd07dfbab)
    results["eve"] = getUserInfo(0x0a4fbf025883f115)
    return results
}

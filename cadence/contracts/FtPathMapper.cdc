import FungibleToken from 0xFUNGIBLETOKEN
import FlowToken from 0xFLOWTOKEN
// import FUSD from "FUSD.cdc"

pub contract FtPathMapper {
    pub let balance: {String:PublicPath}
    pub let receiver: {String:PublicPath}
    pub let storage: {String:StoragePath}

    init() {
        self.balance = {
            Type<&FlowToken.Vault>().identifier: /public/flowTokenBalance,
            Type<@FlowToken.Vault>().identifier: /public/flowTokenBalance
        }
        self.receiver = {
            Type<&FlowToken.Vault>().identifier: /public/flowTokenReceiver,
            Type<@FlowToken.Vault>().identifier: /public/flowTokenReceiver
        }
        self.storage = {
            Type<&FlowToken.Vault>().identifier: /storage/flowTokenVault,
            Type<@FlowToken.Vault>().identifier: /storage/flowTokenVault
        }
    }

    pub fun getReceiver(type: Type, address: Address): Capability<&{FungibleToken.Receiver}> {
        let account = getAccount(address)!
        let path = self.receiver[type.identifier]!
        let ref = account.getCapability<&{FungibleToken.Receiver}>(path)
        assert(ref.check(), message: "Borrow failed")
        return ref
    }

    pub fun getBalance(type: Type, address: Address): Capability<&{FungibleToken.Balance}> {
        let account = getAccount(address)!
        let path = self.balance[type.identifier]!
        let ref = account.getCapability<&{FungibleToken.Balance}>(path)
        assert(ref.check(), message: "Borrow failed")
        return ref
    }
}
 
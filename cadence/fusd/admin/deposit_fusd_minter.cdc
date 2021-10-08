// This transaction creates a new FUSD minter and deposits
// it into an existing minter proxy resource on the specified account.
//
// Parameters:
// - minterAddress: The minter account address.
//
// This transaction will fail if the authorizer does not have the FUSD.Administrator
// resource.
//
// This transaction will fail if the minter account does not have
// an FUSD.MinterProxy resource. Use the setup_fusd_minter.cdc transaction to 
// create a minter proxy in the minter account.

import FUSD from "../../contracts/FUSD.cdc"

transaction(minterAddress: Address) {

    let resourceStoragePath: StoragePath
    let capabilityPrivatePath: CapabilityPath
    let minterCapability: Capability<&FUSD.Minter>

    prepare(adminAccount: AuthAccount) {

        // These paths must be unique within the FUSD contract account's storage
        self.resourceStoragePath = /storage/minter_01
        self.capabilityPrivatePath = /private/minter_01

        // Create a reference to the admin resource in storage.
        let tokenAdmin = adminAccount.borrow<&FUSD.Administrator>(from: FUSD.AdminStoragePath)
            ?? panic("Could not borrow a reference to the admin resource")

        // Create a new minter resource and a private link to a capability for it in the admin's storage.
        let minter <- tokenAdmin.createNewMinter()
        adminAccount.save(<- minter, to: self.resourceStoragePath)
        self.minterCapability = adminAccount.link<&FUSD.Minter>(
            self.capabilityPrivatePath,
            target: self.resourceStoragePath
        ) ?? panic("Could not link minter")

    }

    execute {
        // This is the account that the capability will be given to
        let minterAccount = getAccount(minterAddress)

        let capabilityReceiver = minterAccount.getCapability
            <&FUSD.MinterProxy{FUSD.MinterProxyPublic}>
            (FUSD.MinterProxyPublicPath)!
            .borrow() ?? panic("Could not borrow capability receiver reference")

        capabilityReceiver.setMinterCapability(cap: self.minterCapability)
    }

}

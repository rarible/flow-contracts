// This transaction creates a new minter proxy resource and
// stores it in the signer's account.
//
// After running this transaction, the FUSD administrator
// must run deposit_fusd_minter.cdc to deposit a minter resource
// inside the minter proxy.

import FUSD from "../../contracts/FUSD.cdc"

transaction {

    prepare(minter: AuthAccount) {

        let minterProxy <- FUSD.createMinterProxy()

        minter.save(
            <- minterProxy, 
            to: FUSD.MinterProxyStoragePath,
        )
            
        minter.link<&FUSD.MinterProxy{FUSD.MinterProxyPublic}>(
            FUSD.MinterProxyPublicPath,
            target: FUSD.MinterProxyStoragePath
        )
    }
}

import MotoGPAdmin from "../../../contracts/third-party/MotoGPAdmin.cdc"
import PackOpener from "../../../contracts/third-party/PackOpener.cdc"
import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"
import MotoGPTransfer from "../../../contracts/third-party/MotoGPTransfer.cdc"

transaction(recipientAddress: Address, packId: UInt64, cardIDs: [UInt64], serials: [UInt64]) {
  prepare(acct: AuthAccount) {
    let adminRef = acct.borrow<&MotoGPAdmin.Admin>(from: /storage/motogpAdmin)
    ?? panic("Could not borrow AuthAccount''s Admin reference")
    let packOpenerCollectionRef = getAccount(recipientAddress).getCapability(/public/motogpPackOpenerCollection)!.borrow<&PackOpener.Collection{PackOpener.IPackOpenerPublic}>()
    ?? panic("Could not borrow recipient''s PackOpener collection")
    packOpenerCollectionRef.openPack(adminRef:adminRef, id: packId, cardIDs: cardIDs, serials: serials)
    MotoGPTransfer.topUpFlowForAccount(adminRef: adminRef, toAddress: recipientAddress)
  }
  execute {
  }
}

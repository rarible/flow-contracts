import MotoGPAdmin from "../../../contracts/third-party/MotoGPAdmin.cdc"
import MotoGPPack from "../../../contracts/third-party/MotoGPPack.cdc"
import MotoGPTransfer from "../../../contracts/third-party/MotoGPTransfer.cdc"

transaction(recipients: [Address], packTypes: [UInt64], packNumbers: [[UInt64]]) {
    var recipients: [Address]
    var packTypes: [UInt64]
    var packNumbers: [[UInt64]]
    var ids: [[UInt64]]
    let adminPackCollectionRef: &MotoGPPack.Collection
    let minterRef: &MotoGPAdmin.Admin
    prepare(acct: AuthAccount) {
        self.recipients = recipients
        self.packTypes = packTypes
        self.packNumbers = packNumbers
        self.ids = []
        let length = UInt64(self.recipients.length)
        var i = UInt64(0)
        self.minterRef = acct.borrow<&MotoGPAdmin.Admin>(from: /storage/motogpAdmin)
            ?? panic("Could not borrow the minter reference from the admin")
        while i < length {
            let tempPackType = self.packTypes[i]
            let tempPackNumbers = self.packNumbers[i]
            let tempPackCount = UInt64(tempPackNumbers.length)
            var nextId = MotoGPPack.totalSupply;
            self.minterRef.mintPacks(packType: tempPackType, numberOfPacks: tempPackCount, packNumbers: tempPackNumbers)
            let lastId = MotoGPPack.totalSupply - UInt64(1)
            let idList:[UInt64] = []
            while nextId <= lastId {
                idList.append(nextId)
                nextId = nextId + UInt64(1) 
            }
            self.ids.append(idList)
            i = i + UInt64(1)
        }
        self.adminPackCollectionRef = acct.borrow<&MotoGPPack.Collection>(from: /storage/motogpPackCollection)
        ?? panic("Could not borrow the admin''s pack collection")
    }
    execute {
        let length = UInt64(self.recipients.length)
        var i = UInt64(0)
        while i < length {
            let recipientAccount = getAccount(self.recipients[i])
            let recipientPackCollectionRef = recipientAccount.getCapability(/public/motogpPackCollection)
                .borrow<&MotoGPPack.Collection{MotoGPPack.IPackCollectionPublic}>()
                    ?? panic("Could not borrow the public capability for the recipient''s account")
            let idList = self.ids[i]
            let idListLength = UInt64(idList.length)
            var j = UInt64(0)
            while j < idListLength {
                let packData = self.adminPackCollectionRef.borrowPack(id: idList[j]) ?? panic("Could not borrow the pack from admin''s collection")        
                if packData.packInfo.packType == self.packTypes[i] && packData.packInfo.packNumber == self.packNumbers[i][j] {
                    let pack <- self.adminPackCollectionRef.withdraw(withdrawID: idList[j])
                    recipientPackCollectionRef.deposit(token: <- pack)
                }
                j = j + UInt64(1)
            }
            MotoGPTransfer.topUpFlowForAccount(adminRef: self.minterRef, toAddress: self.recipients[i])
            i = i + UInt64(1)
        }
    }
}

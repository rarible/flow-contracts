import NonFungibleToken from "./contracts/NonFungibleToken.cdc"
import FlowToken from "./contracts/FlowToken.cdc"
import ExampleNFT from "./contracts/ExampleNFT.cdc"
import EnglishAuction from "./contracts/EnglishAuction.cdc"

transaction(lotId: UInt64) {
    let auction: &EnglishAuction.AuctionHouse
    let account: AuthAccount

    prepare(account: AuthAccount) {
        self.auction = EnglishAuction.borrowAuction()
        self.account = account
    }

    execute {
        self.auction.cancelLot(auth: self.account, lotId: lotId)
    }
}

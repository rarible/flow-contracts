#!/usr/bin/env bash
. env.sh

$TXS custom/createItem.cdc "The Collection" "First edition, series one" "0f886aaf9af7b43b97da112d0ba0a559c449710372b8ab93a4be6c91623b92c8"
$TXS custom/createItem.cdc "Cornelius" "#Monke" "02c81e2f902a180b77b5eee3ed809bd248643c0e05e86aacff87e7f973c0ab34"
$TXS custom/createItem.cdc "Socrates" "All I know is that I know nothing." "575321e4441003353228d247ee4d205ca57d6bf3c4a7155caf0f49fd8c7b73f3"
$TXS custom/createItem.cdc "Anatomy" "Orangutan from planet Earth" "0f9474fc921191d798d00b41d8b05bfa6b97bfc43a77f8da3703b423bc9f57e5"
$TXS custom/createItem.cdc "Happy" "There is no need to be upset" "156fff9f3dffcc1e7a0494e4219841e018d7c36bcdf6f17186ddda5c2c834fcc"
$TXS custom/createItem.cdc "Thor" "We are the gods now" "a79be33c7e3cc352a5410809424be8b499ba344822ea6f227cc582f0008f242f"
$TXS custom/createItem.cdc "Drogo" "Reptillian species from Andromeda" "880696f260526cdf5b58c8d4de435c8c353763da28f81d39f4b9151a6cfd0753"
$TXS custom/createItem.cdc "Gekko" "Reptillian species from Vega" "c46ec3bc44820442111c3cb920a260d711ff6fe5697fc5f38e6f9655e633c093"
$TXS custom/createItem.cdc "Cerulean" "Aquatic species from Andromeda" "365871ea019e9ba0da27d21091111dd7d5c16cd5e3c444dd460ebf95b8e3afde"
$TXS custom/createItem.cdc "Tetra" "Aquatic species from Andromeda moon" "dc4bbe4d547de6df0443cc745c199505c5eb86ffbb79cdaef9711620d12abb4a"
$TXS custom/createItem.cdc "Tiburo" "Aquatic predator from Andromeda" "9efb63002f16bd512ef008d4e0383c3dca00cf51806a79682b20777dc87a206c"
$TXS custom/createItem.cdc "Lycan" "Blind predator from Vega" "3dbc2fafb5b604cda32dafc601b2bf069609367d3a5f375f903850326d1de834"
$TXS custom/createItem.cdc "Scythian" "Ruling class from Andromeda" "d0d6e4a7ff61c48cb118e6383137fae39becf1c729638d9566becf4518449db9"
$TXS custom/createItem.cdc "Mako" "Aquatic hunter from Andromeda" "35336d1b3f99d6ecd473518ab8d33c358efbded087220904bb54043ed2934d30"
$TXS custom/createItem.cdc "Xenopod" "Arthropoid species, Andromeda moon" "c9fbc4797d7c6a73c1cbd5455cdcf87ab161bcae8bfe4caf02ce4d9e87d87624"
$TXS custom/createItem.cdc "Harpy" "Aviary species from Andromeda" "115c49bae5df8588af77f912ff8bf5e673ab8922448b56ca18c2db245bf054f0"
$TXS custom/createItem.cdc "Isaac" "Armored species from Vega" "d6bde547967d899a78b5751759e302902f19139ffab7d8c2eb06ab544f187dcb"
$TXS custom/createItem.cdc "Gorgon" "Arthropoid species from Andromeda" "5c17432ecbc3f966906c795f44627f866e35ce1ec306e707a845d47ade9a5306"
$TXS custom/createItem.cdc "Shrike" "Insectoid species from Andromeda" "f89a198288b1b363d28f2d9dc38a70f61dbdbf412ec36bc6a664c783dc1ba443"
$TXS custom/createItem.cdc "Trilobite" "Insectoid species, Andromeda" "e4c285513e47248e4358c6970102cf5f1564c2753e9d68148eefff02873e0e06"
$TXS custom/createItem.cdc "Hilux" "Biological weapon test, Earth" "3e5b091beb834c5971d6ba63839789ce8ea0532ce2c6a85387d19b8fd8fccc05"
$TXS custom/createItem.cdc "Cerulean Hunters" "Tiburo hunting rite of passage" "46e3dbf670d3ce23d497e7fb946137dde0c0dcbc40f084505b276c1a35643130"
$TXS custom/createItem.cdc "Scythian Ruler" "The death king and his lycan" "dbfe5a99c9756472dd473dc6a0ea9853d6c2441422f7f4e0555a0ff47e23f057"
$TXS custom/createItem.cdc "Hilux Origin" "Bio-weapon test, moon facility" "9f70b3415b409fbf708e79ac8a61e6c3db01bdb4f65ee683e89dabc68661fb08"
$TXS custom/createItem.cdc "Proteus" "Shape changing species from Vega" "a465d75192534a575a53835cd4e2c5c4c9eaad7a29651c3168551ff1700ca4f9"
$TXS custom/createItem.cdc "Proteus" "Shape changing species from Vega" "20b1adba54a088629d062878dd6d3d4d2800189c43c193477ad730f68f852efc"
$TXS custom/createItem.cdc "Proteus" "Shape changing species from Vega" "3ec016259b98894b91544e8037fc296ec6d91a4262ffa9280202f20d38a05730"

read -r -p "Original items created. Press enter to continue"

$TXS custom/createSet.cdc "Prima" "first set"
$TXS custom/createSet.cdc "Secunda" "second set"

$TXS custom/addItemsToSet.cdc 1 [1,2,3,5,8,13]
$TXS custom/addItemsToSet.cdc 2 [4,6,7,9,10,11]

$SC custom/getItemsInSet.cdc 1
$SC custom/getItemsInSet.cdc 2

read -r -p "Create and fill some sets. Press enter to finish"

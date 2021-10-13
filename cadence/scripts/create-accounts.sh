#!/usr/bin/env bash
. env.sh

$FLOW accounts create \
	--signer $service \
	--key d0706437543f5af4d151bb6a53e692040eddee9568135263aedd127e814952c6038d489defee54808036d09101c148f8483856a9dd0c0db708e3eddb05652adc

$FLOW accounts create \
	--signer $service \
	--key 6915c04b12b93f442e1a5f9610e11f2250389dfb5e07b40f58c4cc60b78a4e644bf6f9c6eca196db78dbe3359160db698b894306aea4f7bc9eb1a34be53e69d0

$FLOW accounts create \
	--signer $service \
	--key e83db435b9521a454e32597d306dd97f47b18396619e0ca91e632ccb51b065cbe4061b9ce923412174f5a87c3316e34ea347cb59e8cddbd72a235163b69b488d

$FLOW accounts create \
	--signer $service \
	--key bed136471c8af8c3fc0ea17de8b913be8cb6eed04747ac77f8622c9b2893f19f87c20de55e8b6f959795ba8a584d89e7c28680a03c2529c6217b2b0d54016e3e


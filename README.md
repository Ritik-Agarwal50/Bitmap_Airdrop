#### What is a Bitmap?
A bitmap is a data structure that uses bits to represent a set of values or states. Each bit in a bitmap can be either 0 or 1, representing two possible states. In the context of eligibility tracking for an airdrop, each bit can represent whether an address is eligible (1) or not eligible (0).

#### Bitmap in the Airdrop Contract
The bitmap is used to efficiently store and manage the eligibility status of a large number of addresses. Here’s how it works in the contract:

#### Bitmap Structure:

The bitmap is represented as an array of 256-bit integers.
Each 256-bit integer (or word) contains 256 individual bits.
Each bit within these 256-bit words corresponds to the eligibility status of a specific address.
Index Calculation:

#### Word Index (wordIndex): Determines which 256-bit word in the bitmap array contains the bit for a specific address.
#### Bit Index (bitIndex): Determines the position of the specific bit within the 256-bit word.
Example
Consider a bitmap that needs to track the eligibility of 1024 addresses. This would require 4 words (since 1024 / 256 = 4):
    ```Word 0: [bit 0, bit 1, ..., bit 255]
       Word 1: [bit 256, bit 257, ..., bit 511]
       Word 2: [bit 512, bit 513, ..., bit 767]
       Word 3: [bit 768, bit 769, ..., bi  1023]
       ```
### Operations on the Bitmap
### Checking Eligibility
To check if an address at a specific index is eligible, the contract:
1. Calculates wordIndex: index / 256
2. Calculates bitIndex: index % 256
3. Checks the bit:
    1. Constructs a mask with a 1 at the bitIndex position: mask = (1 << bitIndex)
    2. Checks if the bit is set: (bitmap[wordIndex] & mask) == mask

#### Claiming Airdrop
### To claim an airdrop, the contract:
Verifies eligibility using the isEligible function.
1. Calculates wordIndex and bitIndex.
2. Marks the bit as claimed:
3. Constructs a mask to clear the bit: mask = (1 << bitIndex)
4. Clears the bit: bitmap[wordIndex] &= ~mask
# A smart wallet maintained in solidity
I tried to make a wallet using smart contracts. Wrote it in Solidity. 
## Owners and Guardians
1 owner and 5 gurdians. 
### Owner's Role
Can withdraw money without restrictions and can add guardians
### Guardian's Role
Can withdraw a certain amount of money (allowance defined by the owner). Also can change ownership (3 out of 5 should vote for only one person continuously).
## Transfer and Withdraw
Anybody can transfer any amount of money TO it. (So, if someone accidentally transfers to this wallet, then asker the one holding ownership :) ). Withdrawal can only be done by the guardians and the owner.
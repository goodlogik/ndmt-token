let instance = await Token.deployed()
let accounts = await web3.eth.getAccounts()
instance.mint(10000)
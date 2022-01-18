const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // call the makeAnEpicNFT function
  let txn = await nftContract.makeAnEpicNFT();
  //wait for it to be mined
  await txn.wait();
  

  // call the function the second timeout
  txn = await nftContract.makeAnEpicNFT();
  // wait for it it be mined
  await txn.wait();
};

const runMain = async ()=> {
  try {
    await main();
    process.exit(0);
  } catch(error){
    console.log(error);
    process.exit(1);
  }
};
runMain();

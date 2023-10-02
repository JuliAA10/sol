async function main() {
    const ContratoSeguro = await ethers.getContractFactory("ContratoSeguro");
 
    // Start deployment, returning a promise that resolves to a contract object
    const contrato_seguro = await ContratoSeguro.deploy("Contrato Seguro");   
    console.log("Contract deployed to address:", contrato_seguro.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });
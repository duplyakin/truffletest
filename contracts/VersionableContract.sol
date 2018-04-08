pragma solidity ^0.4.17;

import "./Astral.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract SampleToken is MintableToken,iDocument {

function SampleToken(address _owner,iBaseHolder _daoCreator ) public iDocument(_owner,_daoCreator){
      version=2;
}

  string public name = "SampleToken";
  string public symbol = "SMT";
  uint256 public decimals = 18;

}



contract SampleTokenCreator is iCreator{

    function SampleTokenCreator(iBaseHolder _holder) public iCreator(_holder){
      version=2;
    }

    function createDocument(
        address _curator
    ) returns (iDocument _newDocument) {

     /*   dao.push( new DAO(
            _curator,
            this
        ));
        _newDAO = dao[lastContractId];
        lastContractId++;*/
        _newDocument = new SampleToken(_curator,getHolder());

    }
}

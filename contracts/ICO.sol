import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "./Astral.sol";


contract SampleToken is iDocument {

function SampleToken(address _owner,iCreator _creator ) public iDocument(_owner,_creator){
      setVersion(2);
}
  string public name = "SampleToken";
  string public symbol = "SMT";
  uint256 public decimals = 18;

}

contract SampleTokenCreator is iCreator{

    function SampleTokenCreator(iBaseHolder _holder, uint64 _version) public iCreator(_holder, _version) {
    }

    function createDocument(
        address _curator
    ) returns (iDocument _newDocument) {
        _newDocument = new SampleToken(_curator,this);
    }
}

contract SampleContract is iDocument, Crowdsale {

  function SampleContract(address _owner, iCreator _creator ) public iDocument(_owner, _creator) {
        setVersion(2);
  }


}

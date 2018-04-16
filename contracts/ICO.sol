import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "./Astral.sol";


contract SampleToken is iDocument, MintableToken{

  function SampleToken(address _owner, iCreator _creator, string _name, string _symbol, uint256 _decimals ) public iDocument(_owner,_creator){
        setVersion(2);
        name = _name;
        symbol = _symbol;
        decimals= _decimals;
  }
  string public name;
  string public symbol;
  uint256 public decimals;

}

contract SampleTokenCreator is iCreator{

    function SampleTokenCreator(iBaseHolder _holder, uint64 _version) public iCreator(_holder, _version) {
    }

    function createDocumentBuilder (address _curator) public returns (iDocumentBuilder _newDocumentBuilder) {
        _newDocumentBuilder = new SampleTokenBuilder(_curator,this);
    }
}

contract SampleTokenBuilder is iDocumentBuilder{

  string internal name;
  string internal symbol;
  uint256 internal decimals;

  function SampleTokenBuilder  (address _curator, iCreator _creator) public iDocumentBuilder(_curator,_creator){

  }

  function getName() constant onlyOwner public returns (string){
    return name;
  }
  function getSymbol() constant onlyOwner public returns (string){
    return symbol;
  }
  function getDecimals() constant onlyOwner public returns (uint256){
    return decimals;
  }
  function setName(string _name) onlyOwner public{
    name=_name;
  }
  function setSymbol(string _symbol) onlyOwner public{
    symbol=_symbol;
  }
  function setDecimals(uint256 _decimals) onlyOwner public{
    decimals=_decimals;
  }
  function build() public onlyOwner whileNotCreated setCreatedOnSuccess returns (iDocument _doc) {
    require(bytes(name).length>0 && bytes(symbol).length>0 && decimals>0);
    _doc= new SampleToken(owner,creator,name, symbol,decimals);
    creator.getHolder().registerDocument(owner,_doc);
  }
}


contract SampleContract is iDocument, Crowdsale {

  function SampleContract(address _owner, iCreator _creator ) public iDocument(_owner, _creator) {
        setVersion(2);
  }


}


contract IncreasingPriceCrowdsale is iDocument,TimedCrowdsale {
 using SafeMath for uint256;

 uint256 public initialRate;
 uint256 public finalRate;

 /**
  * @dev Constructor, takes intial and final rates of tokens received per wei contributed.
  * @param _initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
  * @param _finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
  */
 function IncreasingPriceCrowdsale(uint256 _initialRate, uint256 _finalRate) public {
   require(_initialRate >= _finalRate);
   require(_finalRate > 0);
   initialRate = _initialRate;
   finalRate = _finalRate;
 }

 /**
  * @dev Returns the rate of tokens per wei at the present time.
  * Note that, as price _increases_ with time, the rate _decreases_.
  * @return The number of tokens a buyer gets per wei at a given time
  */
 function getCurrentRate() public view returns (uint256) {
   uint256 elapsedTime = now.sub(openingTime);
   uint256 timeRange = closingTime.sub(openingTime);
   uint256 rateRange = initialRate.sub(finalRate);
   return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
 }

 /**
  * @dev Overrides parent method taking into account variable rate.
  * @param _weiAmount The value in wei to be converted into tokens
  * @return The number of tokens _weiAmount wei will buy at present time
  */
 function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
   uint256 currentRate = getCurrentRate();
   return currentRate.mul(_weiAmount);
 }

}

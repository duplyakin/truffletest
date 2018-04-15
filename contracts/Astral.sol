pragma solidity ^0.4.17;


import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract iVersionable {

    function iVersionable(   iBaseHolder _holder, uint64 _version
    ) public {
        version = _version;
        holder = _holder;
      //  successor.setVersion(0);
      }

    uint64 public version;
    iBaseHolder public holder;
    iVersionable public successor;

    function getVersion() public view returns (uint64 _version){
        _version=version;
    }
    function setVersion(uint64 _version) internal {
        version=_version;
    }
    function setHolder(iBaseHolder bh) public{
        holder = bh;
    }

    function getHolder() public view returns (iBaseHolder bh){
        bh=holder;
    }

}


contract iBaseHolder{
    function iBaseHolder()public {
        newestVersion=0;
    }

    mapping (uint64 => address) iCreators;
    mapping (uint64 => mapping (address => address)) allDocuments;

    uint64 private newestVersion;
    function updateCreator(address anotherCreator) public {
        iCreator crt = iCreator(anotherCreator);
        uint64 _creatorVersion=crt.getVersion();
        require(_creatorVersion>newestVersion/*,'iCreator is too old, try newer one'*/);
        crt.setHolder(this);
        iCreators[_creatorVersion]=crt;
        newestVersion=_creatorVersion;

    }

    function getCreator(uint64 version) public view  returns (iCreator _creator){
        require(version<=newestVersion/*,'no creator for that version, it\'s unimplemented yet'*/);
        _creator =iCreator( iCreators[version]);
    }

    function getLatestCreator() public view returns (iCreator _creator){
        _creator =getCreator(newestVersion);
    }

    function registerDocument(address _owner, iDocument document) public {

        uint64 _documentVersion=document.getVersion();
        require (_documentVersion<=newestVersion/*,'document source unspecified!'*/);

        mapping (address => address) docsForVersion = allDocuments[_documentVersion];
        address docExists = docsForVersion[_owner];
        require(docExists==0/*,'document already created!'*/);
        docsForVersion[_owner]=document;

    }

}

contract Storage is Ownable{
  function Storage() public Ownable(){
      owner=msg.sender;
  }
  mapping (uint256 => iBaseHolder) holdersByType;

  function getLatestCreator(string contractType) external view returns (iCreator _creator){
     return holdersByType[ uint256(keccak256(contractType))].getLatestCreator();
  }
  function addHolder(string contractType,iBaseHolder holder) public {
     holdersByType[uint256(keccak256(contractType))]=holder;
  }
}

contract iCreator is iVersionable{

    function iCreator(iBaseHolder _holder,uint64 version)public iVersionable(_holder,version){

    }

    function createDocument(address _curator ) public returns (iDocument _newDocument) {
        _newDocument = new iDocument(_curator,this);

    }
}

contract iDocument is iVersionable {
    address public  owner;

    function iDocument(address _owner, iCreator _creator) public iVersionable(_creator.getHolder(),1) {
        iCreator crt1232 = iCreator(_creator);
        owner=_owner;
    }

    function wantSameContract(  address _newOwner) public returns (iDocument _successor) {
        if(successor.getVersion()==0){
            iDocument newDoc = createNewDoc(_newOwner);
            successor=newDoc;
            _successor=newDoc;
        }
    }

    function getOwner() public view returns  (address _owner){
        _owner=owner;
    }

    function createNewDoc(address _newOwner) internal returns (iDocument _newDoc) {
       iBaseHolder holder = getHolder();

       iCreator creator = holder.getLatestCreator();

        _newDoc =creator.createDocument(_newOwner);
           holder.registerDocument(_newOwner, _newDoc);
    }

}

contract SampleToken is iDocument {

function SampleToken(address _owner,iCreator _creator ) public iDocument(_owner,_creator){
      setVersion(2);
}

  string public name = "SampleToken";
  string public symbol = "SMT";
  uint256 public decimals = 18;

}



contract SampleTokenCreator is iCreator{

    function SampleTokenCreator(iBaseHolder _holder,uint64 _version) public iCreator(_holder,_version){
    }

    function createDocument(
        address _curator
    ) returns (iDocument _newDocument) {
        _newDocument = new SampleToken(_curator,this);
    }
}

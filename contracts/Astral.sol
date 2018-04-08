pragma solidity ^0.4.17;


import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract iVersionable {

    function iVersionable(  uint64 _version,
      iBaseHolder _holder) public {
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
    function updateCreator(iCreator anotherCreator) public {
        uint64 _creatorVersion=anotherCreator.getVersion();
        require(_creatorVersion>newestVersion/*,'iCreator is too old, try newer one'*/);
        anotherCreator.setHolder(this);
        iCreators[_creatorVersion]=anotherCreator;
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
  function addHolder(string contractType,iBaseHolder holder) public onlyOwner{
     holdersByType[uint256(keccak256(contractType))]=holder;
  }
}

contract iCreator is iVersionable{

    function iCreator(iBaseHolder _holder)public iVersionable(1,_holder){

    }

    function createDocument(address _curator ) public returns (iDocument _newDocument) {
        _newDocument = new iDocument(_curator,getHolder());

    }
}

contract iDocument is iVersionable {
    address public  owner;

    function iDocument(address _owner, iBaseHolder _daoCreator) public iVersionable(1,_daoCreator) {
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

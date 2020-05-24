pragma solidity 0.6.7;

contract prisonManagement {
	address private admin;
  
	//Modifiers
	modifier onlyAdmin(){
  	require(msg.sender==admin,"Only Admin has Access to this Function!");_;
  }


  //Events
  event Warden_Set(
  	uint id,
  	string first_name,
  	string last_name,
  	string dob,
  	address _address);

    event Prisoner_Set(
  	uint id,
  	string first_name,
  	string last_name,
  	string doj,
  	address _address,
  	string dol);

  constructor() public {
  	admin=msg.sender;
  }

  struct warden{
  	uint id;
  	string first_name;
  	string last_name;
  	string dob;
  }

  mapping (address => warden) Warden;
  address[] public wardens;

  struct prisoner{
  	uint id;
  	string first_name;
  	string last_name;
  	string doj;
  	string dol;
  }

  mapping (address => prisoner) Prisoner;
  address[] public prisoners;

  function set_Warden(uint _id, string memory _first_name, string memory _last_name, string memory _dob, address _address) public onlyAdmin() {
  	warden storage Person = Warden[_address];
  	Person.id=_id;
  	Person.first_name=_first_name;
  	Person.last_name=_last_name;
  	Person.dob=_dob;
  	wardens.push(_address);
  	emit Warden_Set(_id,_first_name,_last_name,_dob,_address);
  }

  function set_Prisoner(uint _id, string memory _first_name, string memory _last_name,string memory _doj, address _address,string memory _dol) public {
  	require(checkWarden(msg.sender)==true,"Only Warden can Add new Prisoners!");
  	prisoner storage Person = Prisoner[_address];
  	Person.id=_id;
  	Person.first_name=_first_name;
  	Person.last_name=_last_name;
  	Person.doj=_doj;
  	Person.dol=_dol;
  	prisoners.push(_address);
  	emit Prisoner_Set(_id,_first_name,_last_name,_doj,_address,_dol);
  }

  function checkWarden(address _address) private view returns(bool){
        bool c=false;
        for(uint32 i=0;i<wardens.length;i++){
            if(_address==wardens[i])
              c=true;
        }
        return(c);
    }
}

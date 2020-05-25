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

  	event prisoner_newCell(
  		address _address,
  		uint _cell);

  	event prisoner_Transferred(
  		address _address,
  		uint _oldcell,
  		uint _newcell);

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
  	uint cell;
  }

  mapping (address => prisoner) public Prisoner;
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

  function set_Cell(address _address,uint _cell) public returns(bool){
  	require(checkWarden(msg.sender)==true,"Only Warden can assign cell numbers");
  	require(checkPrisoner(_address)==true,"Only Prisoners can be in Cells");
  	if(Prisoner[_address].cell==0){
  		Prisoner[_address].cell=_cell;
  		emit prisoner_newCell(_address,_cell);
  	} else {
  		require(Prisoner[_address].cell!=_cell,"Old and New Cell cannot be Same!");
  		prisoner_Transfer(_address,_cell);
  	}

  }

  function prisoner_Transfer(address _address,uint _newcell) private returns(bool){
  	uint oldcell;
  	oldcell = Prisoner[_address].cell;
  	Prisoner[_address].cell=_newcell;
  	emit prisoner_Transferred(_address,oldcell,_newcell);
  }

  function checkPrisoner(address _address) private view returns(bool){
      bool c=false;
      for(uint32 i=0;i<prisoners.length;i++){
          if(_address==prisoners[i])
            c=true;
      }
      return(c);
  }
}

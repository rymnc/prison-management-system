pragma solidity 0.6.7;

contract prisonManagement {
    address private admin;

    //Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin has Access to this Function!");
        _;
    }

    //Events
    event Warden_Set(
        uint256 id,
        string first_name,
        string last_name,
        string dob,
        address _address
    );

    event Prisoner_Set(
        uint256 id,
        string first_name,
        string last_name,
        string doj,
        address _address,
        string dol,
        string belongings,
        string medicalhistory
    );

    event prisoner_newCell(address _address, uint256 _cell);

    event prisoner_Transferred(
        address _address,
        uint256 _oldcell,
        uint256 _newcell
    );

    event JobProvider_Set(
        uint256 id,
        string name,
        string jobs,
        address _address
    );

    event Jobs_Updated(string jobs);

    event Prisoner_newJob(string name, string job);

    event new_Security(string name, address _address);

    event security_newAssignment(string name, string assignment);

    event security_changedAssignment(
        string name,
        string oldassignment,
        string newassignment
    );

    constructor() public {
        admin = msg.sender;
    }

    struct warden {
        uint256 id;
        string first_name;
        string last_name;
        string dob;
    }

    mapping(address => warden) Warden;
    address[] public wardens;

    struct prisoner {
        uint256 id;
        string first_name;
        string last_name;
        string doj;
        string dol;
        uint256 cell;
        string belongings;
        string medical;
        //string job;
    }

    struct jobProvider {
        uint256 id;
        string name;
        string jobs;
    }

    struct workingJobs {
        string work;
    }

    struct Security {
        uint256 id;
        string name;
        string assignment;
    }

    mapping(address => Security) public security;

    mapping(address => workingJobs) public WorkingPrisoner;

    mapping(address => jobProvider) public JobProvider;

    mapping(address => prisoner) public Prisoner;
    address[] public prisoners;

    function set_Warden(
        uint256 _id,
        string memory _first_name,
        string memory _last_name,
        string memory _dob,
        address _address
    ) public onlyAdmin() {
        warden storage Person = Warden[_address];
        Person.id = _id;
        Person.first_name = _first_name;
        Person.last_name = _last_name;
        Person.dob = _dob;
        wardens.push(_address);
        emit Warden_Set(_id, _first_name, _last_name, _dob, _address);
    }

    function set_Prisoner(
        uint256 _id,
        string memory _first_name,
        string memory _last_name,
        string memory _doj,
        address _address,
        string memory _dol,
        string memory _belongings,
        string memory _medical
    ) public {
        require(
            checkWarden(msg.sender) == true,
            "Only Warden can Add new Prisoners!"
        );
        prisoner storage Person = Prisoner[_address];
        Person.id = _id;
        Person.first_name = _first_name;
        Person.last_name = _last_name;
        Person.doj = _doj;
        Person.dol = _dol;
        Person.belongings = _belongings;
        Person.medical = _medical;
        prisoners.push(_address);
        emit Prisoner_Set(
            _id,
            _first_name,
            _last_name,
            _doj,
            _address,
            _dol,
            _belongings,
            _medical
        );
    }

    function set_JobProvider(
        uint256 _id,
        string memory _name,
        string memory _jobs,
        address _address
    ) public {
        require(
            checkWarden(msg.sender) == true,
            "Only Warden can Add new Job Provider!"
        );
        jobProvider storage Person = JobProvider[_address];
        Person.id = _id;
        Person.name = _name;
        Person.jobs = _jobs;
        emit JobProvider_Set(_id, _name, _jobs, _address);
    }

    function update_Jobs(string memory _jobs) public {
        require(
            JobProvider[msg.sender].id != 0,
            "Only Job Providers can access this function"
        );
        require(
            hashCompareWithLengthCheck(JobProvider[msg.sender].jobs, _jobs) ==
                false,
            "Update must be met"
        );
        JobProvider[msg.sender].jobs = _jobs;
        emit Jobs_Updated(_jobs);
    }

    function set_Work(string memory _jobwork, address _address) public {
        require(
            JobProvider[msg.sender].id != 0,
            "Only Job Providers can access this function"
        );
        require(
            hashCompareWithLengthCheck(
                WorkingPrisoner[_address].work,
                _jobwork
            ) == false,
            "Update must be met"
        );
        require(
            checkPrisoner(_address) == true,
            "Only Prisoners can have Jobs!"
        );
        workingJobs storage Person = WorkingPrisoner[_address];
        Person.work = _jobwork;
        emit Prisoner_newJob(Prisoner[_address].first_name, _jobwork);
    }

    function set_Security(
        uint256 _id,
        string memory _name,
        address _address
    ) public {
        require(
            checkWarden(msg.sender) == true,
            "Only Warden can assign cell numbers"
        );
        require(
            checkPrisoner(_address) == false,
            "Prisoners cannot be security"
        );
        Security storage Person = security[_address];
        Person.id = _id;
        Person.name = _name;
        emit new_Security(_name, _address);
    }

    function set_AssignmentSecurity(address _address, string memory _assignment)
        public
    {
        require(
            checkWarden(msg.sender) == true,
            "Only Warden can assign cell numbers"
        );
        require(
            security[_address].id != 0,
            "Only Security can have Assignments"
        );
        if (
            hashCompareWithLengthCheck(security[_address].assignment, "") ==
            true
        ) {
            security[_address].assignment = _assignment;
            emit security_newAssignment(security[_address].name, _assignment);
        } else {
            require(
                hashCompareWithLengthCheck(
                    security[_address].assignment,
                    _assignment
                ) == false,
                "Old and New Assignment cannot be same"
            );
            change_AssignmentSecurity(_address, _assignment);
        }
    }

    function change_AssignmentSecurity(
        address _address,
        string memory _assignment
    ) private {
        string memory oldassignment = security[_address].assignment;
        security[_address].assignment = _assignment;
        emit security_changedAssignment(
            security[_address].name,
            oldassignment,
            _assignment
        );
    }

    function checkWarden(address _address) private view returns (bool) {
        bool c = false;
        for (uint32 i = 0; i < wardens.length; i++) {
            if (_address == wardens[i]) c = true;
        }
        return (c);
    }

    function set_Cell(address _address, uint256 _cell) public returns (bool) {
        require(
            checkWarden(msg.sender) == true,
            "Only Warden can assign cell numbers"
        );
        require(
            checkPrisoner(_address) == true,
            "Only Prisoners can be in Cells"
        );
        if (Prisoner[_address].cell == 0) {
            Prisoner[_address].cell = _cell;
            emit prisoner_newCell(_address, _cell);
        } else {
            require(
                Prisoner[_address].cell != _cell,
                "Old and New Cell cannot be Same!"
            );
            prisoner_Transfer(_address, _cell);
        }
    }

    function prisoner_Transfer(address _address, uint256 _newcell) private {
        uint256 oldcell;
        oldcell = Prisoner[_address].cell;
        Prisoner[_address].cell = _newcell;
        emit prisoner_Transferred(_address, oldcell, _newcell);
    }

    function checkPrisoner(address _address) private view returns (bool) {
        bool c = false;
        for (uint32 i = 0; i < prisoners.length; i++) {
            if (_address == prisoners[i]) c = true;
        }
        return (c);
    }

    function hashCompareWithLengthCheck(string memory a, string memory b)
        private
        pure
        returns (bool)
    {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return
                keccak256(abi.encodePacked(a)) ==
                keccak256(abi.encodePacked(b));
        }
    }
}

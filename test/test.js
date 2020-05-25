let pm = artifacts.require("./prisonManagement.sol");
let pminstance;



contract('prisonManagement', function (accounts) {
  //accounts[0] is the default account
  //Test case 1
  it("Contract Deployed", function() {
    return pm.deployed().then(function (instance) {
      pminstance = instance;
      assert(pminstance !== undefined, 'Prison Management contract should be defined');
    });
  });

  it("Adds new Warden", function(){
  	return pminstance.set_Warden("12","Ajay","Nager","20/04/2020",accounts[1]).then( function(result){
  		assert(pminstance.wardens[0]!=0,"Valid Warden add");
  	});
  });

  it("Only Admin can add Warden", function(){
  	return pminstance.set_Warden("12","Ajay","Nager","20/04/2020",accounts[1],{from:accounts[3]}).then( function(result){
  		throw("Modifier issue");
  	}).catch( function(e){
  		if(e==="Modifier issue"){
  			assert(false);
  		} else {
  			assert(true);
  		}
  	})
  });

  it("Adds new Prisoner",function(){
  	return pminstance.set_Prisoner("12","Ajay","Nager","20/04/2020",accounts[3],"20/04/2040","broke","diabetes",{from:accounts[1]}).then( function(result){
  		assert(pminstance.prisoners[0]!=0,"Valid Prisoner Add");
  	});
  });

  it("Only Warden can add Prisoner",function(){
  	return pminstance.set_Prisoner("12","Ajay","Nager","20/04/2020",accounts[1],"20/04/2040","100$","Leprosy",{from:accounts[3]}).then(function (result){
  		throw("Modifier issue");
  	}).catch(function(e){
  		if(e==="Modifier issue"){
  			assert(false);
  		} else {
  			assert(true);
  		}
  	})
  });

  it("Can Set Cell of new Prisoner",function(){
  	return pminstance.set_Cell(accounts[3],"23",{from:accounts[1]}).then(function (result){
  		let data = pminstance.Prisoner.call(accounts[1]);
  		assert(data.cell!=0,"Valid Cell Set");
  	});
  });

  it("Only Warden can Set Cell of Prisoner",function(){
  	return pminstance.set_Cell(accounts[3],"12",{from:accounts[2]}).then(function (result){
  		throw("Modifier issue");
  	}).catch( function(e){
  		if(e==="Modifier issue"){
  			assert(false);
  		} else{
  			assert(true);
  		}
  	})
  });

  it("Can Transfer Prisoner between Cells",function(){
  	return pminstance.set_Cell(accounts[3],"17",{from:accounts[1]}).then(function (result){
  		let data = pminstance.Prisoner.call(accounts[3]);
  		assert(data.cell!=0,"Valid Cell Transfer");
  	});
  });

   it("Only Prisoners can be put in cells",function(){
   	 return pminstance.set_Cell(accounts[2],"18",{from:accounts[1]}).then(function (result){
   	 throw("Only Prisoners")

   	 }).catch(function(e){
   	 	if(e==="Only Prisoners"){
   	 		assert(false);
   	 	} else {
   	 		assert(true);
   	 	}
   	 })
   });

   it("Old and New Cell Cannot be the Same!",function(){
   	 return pminstance.set_Cell(accounts[3],"17",{from:accounts[1]}).then(function (result){
   	 	throw("Old not New");
   	 }).catch(function (e){
   	 	if(e==="Old not New") {
   	 		assert(false);
   	 	} else {
   	 		assert(true);
   	 	}
   	 })
   });

   it("Can set Job Provider",function(){
   	return pminstance.set_JobProvider("18","Kamlesh","Mining,Laundry,Scrapping",accounts[5],{from:accounts[1]}).then(function (result){
   		let data = pminstance.JobProvider.call(accounts[5]);
   		assert(data.id!=0,"Valid Job Provider Creation");
   	});
   });

   it("Only Warden Can set Job Provider",function(){
   	return pminstance.set_JobProvider("18","Kamlesh","Mining,Laundry,Scrapping",accounts[5],{from:accounts[2]}).then(function (result){
   		throw("Modifier issue");
   	}).catch(function(e){
   		if(e==="Modifier issue"){
   			assert(false);
   		} else {
   			assert(true);
   		}
   	})
   });

   it("Should allow Updation of Jobs",function(){

   	return pminstance.update_Jobs("Mining,Laundry",{from:accounts[5]}).then(function(result){
   		let data = pminstance.JobProvider.call(accounts[5]);
   		assert(data.jobs!='',"Valid Job Updation");

   	});
   });

   it("Should allow Updation of Jobs only by Job Provider",function(){
   	return pminstance.update_Jobs("Mining",{from:accounts[0]}).then(function(result){
   		throw("Modifier issue");
   	}).catch(function(e){
   		if(e==="Modifier issue") {
   			assert(false);
   		} else {
   			assert(true);
   		}
   	})
   });

   it("Old Jobs and New Jobs must not be the same",function(){
   	pminstance.update_Jobs("Mining,Laundry",{from:accounts[5]}).then(function(result){
   		throw("Old Not New");
   	}).catch(function(e){
   		if(e==="Old Not New") {
   			assert(false);
   		} else {
   			assert(true);
   		}
   	})
   });
});
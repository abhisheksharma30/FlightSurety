pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/
	
	struct Insurance {

		uint insuranceNo;
		uint flightId;
		uint flightTime;
		uint payoutApplicable;	
	}	



    struct Airline {
			string airlineName;
			uint isRegistered;
			uint isFunded;
			uint fundedAmount;
   }
	
	uint public airlineCounter=0;
	
	uint private insuranceId=1;
		
	
	  // Define a public mapping 'items' that maps the airline details to airlineaddress.
    mapping (address => Airline) airlines;
  
  
  	  // Define a public mapping 'items' that maps the passenger address  details to insurance purchased by him.
    mapping (address => Insurance) insureeMappping;
	
	mapping(address => address[]) votes;				// Votes for multi-party consensus

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor() public 
    {
        contractOwner = msg.sender;
		
	}

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline ( string _airlineName, address _airlineAddress, address _senderAddress) 
    {
		Airline memory airline=  Airline(_airlineName,1,0,0);

	// Validation is not required while registering first airline
		if(airlineCounter==0)
		{
		airlines[_airlineAddress] = airline;
        airlineCounter=airlineCounter.add(1);
		}
		
		
	// Validation that only registered airline can register a new airline
		else if (airlineCounter==1 && airlineCounter<=2) {
		require(airlines[_senderAddress].isRegistered==1,"Sender not authorized to register airline");
		
		airlines[_airlineAddress] = airline;
        airlineCounter=airlineCounter.add(1);
		}
		
	// validation that 50% of registered airlines have voted for registration of new airline
	 else{
		  if(airlines[_senderAddress].isRegistered==1)
		    votes[_airlineAddress].push(_senderAddress);
			
		  if(((votes[_airlineAddress].length)*2)>airlineCounter) {
			airlines[_airlineAddress] = airline;
			airlineCounter=airlineCounter.add(1);
			
		  }
		}
      }

	

	   /**
    * Get airline method
    *
    */ 

	function getAirline(address _airlineAddress) public view returns (string airlineName, uint isRegistered,uint isFunded, uint fundedAmount)
	{
	
		Airline memory i = airlines[_airlineAddress];
		return (
			i.airlineName,
			i.isRegistered,
			i.isFunded,
			i.fundedAmount);
	
	}



	function getSampleDataAirline(address _airlineAddress) public view returns (string airlineName)
	{
	
		Airline memory i = airlines[_airlineAddress];
		airlineName=i.airlineName;
		
	}
		   /**
    * Get insurance method
    *
    */ 

	function getInsurance(address _passengerAddress) public view returns (uint airlineName, uint isRegistered,uint isFunded, uint fundedAmount)
	{
	
		Insurance memory i = insureeMappping[_passengerAddress];
		return (
			i.insuranceNo,
			i.flightId,
			i.flightTime,
			i.payoutApplicable);
	
	}
	
			   /**
    * Get airline counter 
    *
    */

	 function getAirlineCounter () returns (uint)
    {
        return airlineCounter;
    }

   
    /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (   

							uint flightId,
							uint flightTime,
							address _sender
                            )
                                                 
    {


	 Insurance memory i;
	 i.insuranceNo= insuranceId;
	 i.flightId=flightId;
	 i.flightTime=flightTime;
	 i.payoutApplicable=0;
	 insuranceId=insuranceId.add(1);
	 require(flightId==901,"FLight id not equal to 901");
	 require(flightTime==1300,"FLight time is not equal to 1300");
	 require(_sender==0x411468c790297933f75d2e9d5495371ba70d4969,"Passenger address is not correct");
	 insureeMappping[_sender]=i;
	 
	 }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
								
                                )
                                external
                                
    {
		insureeMappping[msg.sender].payoutApplicable=1;
	}
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
							 address payoutAddress
                            )
                            external
                            
    {
	
		uint payoutAmount = 1.5 ether;
		require(insureeMappping[payoutAddress].payoutApplicable==1);
		payoutAddress.transfer(payoutAmount);
		insureeMappping[payoutAddress].payoutApplicable=0;
		

    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund
                            ( 
							address _sender		
                            )
                            public
                            payable
    { 
	 airlines[_sender].isFunded = 1;
	 airlines[_sender].fundedAmount = msg.value;
	
    }
	
	


    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }
	
	

	
	
	
	
	

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function() 
                            external 
                            payable 
    {
       // fund();
    }




}


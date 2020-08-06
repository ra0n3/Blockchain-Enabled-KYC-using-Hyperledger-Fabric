package main

import (
	"fmt"
	"strconv"

	// April 2020, Updated to Fabric 2.0 Shim
	"github.com/hyperledger/fabric/core/chaincode/shim"
	peer "github.com/hyperledger/fabric/protos/peer"

	// Conversion functions
	// "strconv"

	// JSON Encoding
	"encoding/json"
)

const prefixUser = "user."

//KYCChaincode represents chaincode object
type KYCChaincode struct {
}

// user structure manages the state
type user struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	UserName  string `json:"userName"`
}

// Init Implements the Init method
// Receives 3 parameters =  [0] FirstName [1] LastName   [2] UserName
func (kyc *KYCChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {

	// Simply print a message
	fmt.Println("Init executed")
	_, args := stub.GetFunctionAndParameters()

	// Check if we received the right number of arguments
	if len(args) < 3 {
		return shim.Error("Failed - incorrect number of parameters!! ")
	}

	firstname := string(args[0])
	lastname := string(args[1])
	username := string(args[2])

	var users = user{FirstName: firstname, LastName: lastname, UserName: username}

	jsonUser, _ := json.Marshal(users)
	//stub.PutState("token", []byte(jsonERC20))

	//KEY FOR user representation
	key := prefixUser + username
	fmt.Println("Key=", key)

	err := stub.PutState(key, []byte(jsonUser))
	if err != nil {
		return errorResponse(err.Error(), 4)
	}

	return shim.Success([]byte(jsonUser))
}

func (kyc *KYCChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	// Get the function name and parameters
	function, args := stub.GetFunctionAndParameters()

	fmt.Println("Invoke executed : ", function, " args=", args)

	switch {

	// Query function
	case function == "getUser":
		return getUser(stub, args)
	case function == "setUser":
		return setUser(stub, args)
		// case	function == "transfer":
		// 		return transfer(stub, args)
	}

	return errorResponse("Invalid function", 1)
}

func getUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 1 {
		return errorResponse("Needs username!!!", 6)
	}

	user := user{}

	username := args[0]
	bytes, err := stub.GetState(prefixUser + username)
	if err != nil {
		return errorResponse(err.Error(), 7)
	}

	_ = json.Unmarshal(bytes, &user)

	userMarshed, err := json.Marshal(user)
	
	return successResponse(string(userMarshed))
	// return successResponse(response)
}

func setUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// Simply print a message
	fmt.Println("setUser executed")
	// _, args := stub.GetFunctionAndParameters()

	// Check if we received the right number of arguments
	if len(args) < 3 {
		return shim.Error("Failed - incorrect number of parameters!! ")
	}

	firstname := string(args[0])
	lastname := string(args[1])
	username := string(args[2])

	var users = user{FirstName: firstname, LastName: lastname, UserName: username}

	jsonUser, _ := json.Marshal(users)
	//stub.PutState("token", []byte(jsonERC20))

	//KEY FOR user representation
	key := prefixUser + username
	fmt.Println("Key=", key)

	err := stub.PutState(key, []byte(jsonUser))
	if err != nil {
		return errorResponse(err.Error(), 4)
	}

	return shim.Success([]byte(jsonUser))

}

// func balanceJSON(username, balance string) (string) {
// 	return "{\"owner\":\""+OwnerID+"\", \"balance\":"+balance+ "}"
// }

func errorResponse(err string, code uint) peer.Response {
	codeStr := strconv.FormatUint(uint64(code), 10)
	// errorString := "{\"error\": \"" + err +"\", \"code\":"+codeStr+" \" }"
	errorString := "{\"error\":" + err + ", \"code\":" + codeStr + " \" }"
	return shim.Error(errorString)
}

func successResponse(dat string) peer.Response {
	success := "{\"response\": " + dat + ", \"code\": 0 }"
	return shim.Success([]byte(success))
}

// Chaincode registers with the Shim on startup
func main() {
	fmt.Println("Started....")
	err := shim.Start(new(KYCChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}

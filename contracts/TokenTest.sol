import "./Token.sol";
import "../node_modules/truffle/build/Assert.sol";
contract TokenTest {
    function testCostruct() public {
        Token token = new Token("TKN","TK");
        Assert.equal(token.owner(),msg.sender,"wrong owner");  //we own this token, since we depolyed it
        
    }
}

//this is one way to write tests, as an contract that calls functions
//the other option is to use javascript to write unit tests
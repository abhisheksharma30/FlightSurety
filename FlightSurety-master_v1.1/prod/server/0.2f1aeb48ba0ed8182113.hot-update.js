exports.id=0,exports.modules={"./src/server/server.js":function(e,s,r){"use strict";r.r(s);var o=r("./build/contracts/FlightSuretyApp.json"),t=r("./src/server/config.json"),n=r("web3"),c=r.n(n),a=r("express"),l=r.n(a),p=t.localhost,i=new c.a(new c.a.providers.WebsocketProvider(p.url.replace("http","ws")));i.eth.defaultAccount=i.eth.accounts[0];var u=new i.eth.Contract(o.abi,p.appAddress);myContractInstance.registerOracle();console.log("config app address=",p.appAddress),u.events.OracleRequest({fromBlock:0},function(e,s){e&&console.log(e),console.log(s)});var d=l()();d.get("/api",function(e,s){s.send({message:"An API for use with your Dapp!"})}),s.default=d}};
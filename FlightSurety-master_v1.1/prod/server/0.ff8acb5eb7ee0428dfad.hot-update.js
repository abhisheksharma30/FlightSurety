exports.id=0,exports.modules={"./src/server/server.js":function(e,s,r){"use strict";r.r(s);var o=r("./build/contracts/FlightSuretyApp.json"),t=r("./src/server/config.json"),a=r("web3"),c=r.n(a),n=r("express"),p=r.n(n),l=t.localhost,d=new c.a(new c.a.providers.WebsocketProvider(l.url.replace("http","ws")));d.eth.defaultAccount=d.eth.accounts[0];var i=new d.eth.Contract(o.abi,l.appAddress);d.eth.contract(o.abi).at(l.appAddress).registerOracle();console.log("config app address=",l.appAddress),i.events.OracleRequest({fromBlock:0},function(e,s){e&&console.log(e),console.log(s)});var u=p()();u.get("/api",function(e,s){s.send({message:"An API for use with your Dapp!"})}),s.default=u}};
exports.id=0,exports.modules={"./src/server/server.js":function(e,s,r){"use strict";r.r(s);var o=r("./build/contracts/FlightSuretyApp.json"),t=r("./src/server/config.json"),n=r("web3"),c=r.n(n),a=r("express"),l=r.n(a),i=t.localhost,p=new c.a(new c.a.providers.WebsocketProvider(i.url.replace("http","ws")));p.eth.defaultAccount=p.eth.accounts[0];var u=new p.eth.Contract(o.abi,i.appAddress);console.log("config app address=",i.appAddress),u.events.OracleRequest({fromBlock:0},function(e,s){e&&console.log(e),console.log(s)}),u.registerOracle(function(e,s){console.log("inside register")});var d=l()();d.get("/api",function(e,s){s.send({message:"An API for use with your Dapp!"})}),s.default=d}};
var mypengine;

function new_data(){
	if(this.data && this.data[0] && this.data[0].Result != undefined) {
		console.log("Data is " + this.data[0].Result.toString());
	}
}
function startGame() {
	mypengine = new Pengine({
		ask: "create_game(Result)",
		onsuccess: new_data,
		application: "ldjam_pengine_app"
	});
}

function sendPengine() {
  var query = $("#counter").text();
  console.log("Query will be: " + query);
  mypengine.ask('increase(' + query + ', Result)');
};

window.onload = startGame;

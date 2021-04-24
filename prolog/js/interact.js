var mypengine;

function new_data(){
	if(this.data && this.data[0] && this.data[0].Result != undefined) {
    var cardObj = this.data[0].Result;
		console.log("Data is " + cardObj.toString());
		// Hans - this.data[0].Result is a json object I hope
    console.log("HTML instruction", cardObj.show.toString());
    displayCard(cardObj);
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

function displayCard(aCardObj)
{
  var html = aCardObj.show;
  $("#card").append(html);

  displayButtons(aCardObj);
}

function displayButtons(aCardObj)
{
    var buttonObj = aCardObj.buttons[0].args;
    var html = buildButton(buttonObj[0])
     $("#buttonArea").append(html);

    console.log("Buttons ", buttonObj)
}

function buildButton(name)
{
  var html = '<button id = "' + name + '"">'+ name + '</button>';
  return html; 
}
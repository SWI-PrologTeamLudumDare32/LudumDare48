// hold the Pengine object
var mypengine;
// hold the current card so that it can be send back to Prolog for processing the next card
var lastCard; 

// Data from Pengine comming
function new_data(){
	if(this.data && this.data[0] && this.data[0].Result != undefined) {
    var cardObj = this.data[0].Result;
		console.log("Data is " + cardObj.toString());
		// Hans - this.data[0].Result is a json object I hope
    console.log("HTML instruction", cardObj.show.toString());
    displayCard(cardObj);
    lastCard = cardObj; 
	}
}

// overall start
function startGame() {
	mypengine = new Pengine({
		ask: "create_game(Result)",
		onsuccess: new_data,
<<<<<<< HEAD
		application: "ldjam_pengine_app",
    destroy: false
=======
		destroy: false,
		application: "ldjam_pengine_app"
>>>>>>> 6c8f2d42176282e4a15cda6200f9c76e3e7fad0a
	});
}

// send a query to Pengine
function sendPengine(Par) {
  //var query = $("#counter").text();
  var query = 'next_card('+ JSON.stringify(lastCard) + ',' + Par +', Result)';
  console.log("Query will be: " + query);
  mypengine.ask(query);
};

window.onload = startGame;

// display the card
function displayCard(aCardObj)
{
  var html = aCardObj.show;
  $("#card").empty(); 
  $("#card").append(html);

  displayButtons(aCardObj);
}

// display the buttons of a card, replace the old one
function displayButtons(aCardObj)
{
    var buttonObj = aCardObj.buttons[0].args;
    var html = buildButton(buttonObj[0], buttonObj[1])
    $("#buttonArea").empty();
    $("#buttonArea").append(html);

    console.log("Buttons ", buttonObj)
}

// create a new button for html
function buildButton(name, Par)
{
  var parText = "'" + Par + "'";
  // different ways are possible to send the Par to Pengine, this is just one suggestion
  // best way depends on how to process the next card
  // here, the from the [Name = Value] pair of a button the Value is here the Par
  // and this would mean Prolog decides by this Value which card is next
  var html = '<button id = "' + name + '" onclick="sendPengine('+ parText +')">'+ name + '</button>';
  console.log("HTML Text: ", html);
  return html; 
}
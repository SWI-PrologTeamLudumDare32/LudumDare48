// hold the Pengine object
var mypengine;
// hold the current card so that it can be send back to Prolog for processing the next card
// Hans, we only need the name from the button field
// you don't need to pass the whole object back, just the name for the card you want
var lastCard; 

// Data from Pengine comming
function new_data(){
	if(this.data && this.data[0] && this.data[0].Result != undefined) {
    		lastCard = this.data[0].Result;
    		displayCard(lastCard);
	}
	if(this.more) {
		mypengine.stop();
	}
}

// overall start
function startGame() {
	mypengine = new Pengine({
		ask: "create_game(Result)",
		onsuccess: new_data,
		application: "ldjam_pengine_app",
		destroy: false,
		onfailure: () => console.log('engine fails'),
		onerror: engine_error
	});
}

function engine_error() {
	console.log(this.data);
}

// send a query to Pengine, when it returns new_data is called and the card
// replaced
function advanceToNextCard(NextCard) {
  var query = 'next_card(\''+ NextCard +'\', Result)';
  console.log("Query will be: " + query);
  mypengine.ask(query);
};


// display the card
function displayCard(aCardObj)
{
  var html = aCardObj.show;
  $("#card").empty(); 
  $("#card").append(html);

  displayButtons(aCardObj.buttons);
}

// display the buttons of a card, replace the old ones
function displayButtons(buttons)
{
	let html = '';
	
	for (i in buttons) {
    		html += buildButton(buttons[i].label, buttons[i].go, buttons[i].reveal);
    	}
    $("#buttonArea").empty();
    $("#buttonArea").append(html);

    //console.log("Buttons ", html)
}

function donothing() {
	;
}

// perform the reveal and then call the callback
function doReveal(text, callback) {

//console.log("Reveal text", text);
  if (text != '')
  {
     var node = decodeURI(text);
     $("#revealArea").empty();
     $("#revealArea").append('<div id="spookyText">' + node + '</div>');
     setTimeout(callback, 4000);
  }
  else 
	callback();
}

const backslash = String.fromCharCode(92);

// .replaceAll("\"", "\\\"")
// .replaceAll("'", "\\'") 
// create html for a new button
function buildButton(label, go, reveal)
{
	let escgo = go.replaceAll(/'/g, backslash.concat("'"));
	let escreveal = encodeURI(reveal).replaceAll(/'/g, backslash.concat("'"));

	if(go != '' && reveal != '') {
		return '<button onclick="doReveal(\''.concat(
			escreveal).concat(
		        '\', () => { advanceToNextCard(\'').concat(
		        escgo).concat(
		        '\');})">').concat(
		         label).concat( 
		         '</button>');
	} else if (go != '') {
		return '<button onclick="advanceToNextCard(\'' + escgo + '\')">' + label + '</button>';
	} else if (reveal != '') {
		return '<button onclick="doReveal(\'' + escreveal + '\', donothing)">' + label + '</button>';
	} else {
		return '<button disabled>' + label + '</button>';
	}
}


window.onload = startGame;


// hold the Pengine object
var mypengine;
// hold the current card so that it can be send back to Prolog for processing the next card
// Hans, we only need the name from the button field
// you don't need to pass the whole object back, just the name for the card you want
var lastCard; 
var audioElement = [];
var currentDream; 
var currentSound = null; 

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

	try {
		audioElement["JUNGLEDREAM"] = new Audio('/audio/Nightmare.mp3');
		audioElement["WETDREAM"] = new Audio('/audio/Dream-transition1.mp3');
		audioElement["SECRETDREAM"] = new Audio('/audio/Happy-theme.mp3');
		audioElement["GOLDFISHBOWLDREAM"] = new Audio('/audio/LD48-firstkiss-hank.mp3');
		audioElement["EPICBATTLEDREAM"] = new Audio('/audio/ld_48_3_atschool-hank.mp3');
		audioElement["GARDENGNOMEDREAM"] = new Audio('/audio/ld_48_teethonadate-hank.mp3');
		audioElement["OVERWORLDINTRODREAM"] = new Audio('/audio/main.mp3');
		audioElement["SPACEDREAM"] = new Audio('/audio/Space-theme.mp3');
		audioElement["ALLIGATORINASWIMMINGPOOLDREAM"] = new Audio('/audio/Nightmare2.mp3');
	}
	catch(err)
	{
		console.log("Error loading sound : ", err);
	}
	

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
  //console.log("Query will be: " + query);
  mypengine.ask(query);
};


// display the card
function displayCard(aCardObj)
{
  var html = aCardObj.show;
  currentDream = nameOfDream(aCardObj.name); 
  console.log("Current Dream", currentDream);
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

	try {
		// stop playing old sound
		if (currentSound) 
			currentSound.pause(); 
				
		currentSound = audioElement[currentDream];
		currentSound.play();
	}
	catch(err)
	{
		console.log("Sound " + currentDream + " not available");
	}

  if (text != '')
  {
     var node = decodeURI(text);
     //console.log("Reveal text", text);
     $("#revealArea").empty();
     $("#revealArea").append('<div id="spookyText">' + node + '</div>');
     setTimeout(callback, 6000);
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

function nameOfFile(Path)
{
	p1 = Path.substring(test.lastIndexOf('/')+1);
	return p1.substring(0, p1.lastIndexOf('.'))
}

function nameOfDream(DreamIdentifier)
{
	return DreamIdentifier.substring(0, DreamIdentifier.lastIndexOf('!')-1);
}

window.onload = startGame;


// hold the Pengine object
var mypengine;
// hold the current card so that it can be send back to Prolog for processing the next card
// Hans, we only need the name from the button field
// you don't need to pass the whole object back, just the name for the card you want
var lastCard; 

var audioElement = [];


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

	audioElement["Nightmare"] = new Audio('/audio/Nightmare.mp3');
	audioElement["Dream-transition1"] = new Audio('/audio/Dream-transition1.mp3');
	audioElement["Happy-theme"] = new Audio('/audio/Happy-theme.mp3');
	audioElement["LD48-firstkiss-hank"] = new Audio('/audio/LD48-firstkiss-hank.mp3');
	audioElement["ld_48_3_atschool-hank"] = new Audio('/audio/ld_48_3_atschool-hank.mp3');
	audioElement["ld_48_teethonadate-hank"] = new Audio('/audio/ld_48_teethonadate-hank.mp3');
	audioElement["main"] = new Audio('/audio/main.mp3');
	audioElement["Space-theme"] = new Audio('/audio/Space-theme.mp3');

	mypengine = new Pengine({
		ask: "create_game(Result)",
		onsuccess: new_data,
		application: "ldjam_pengine_app",
		destroy: false,
		onfailure: () => console.log('engine fails'),
		onerror: () => console.log('engine error', this.data),
	});
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
  console.log("HRML", aCardObj.buttons);
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

// you have do get the filename of the soundfile somehow -> audio tag in reveal text?
//key = nameOfFile(filename);
//audioElement[key].play();

console.log("Reveal text", text);
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

function nameOfFile(Path)
{
	p1 = Path.substring(test.lastIndexOf('/')+1);
	return p1.substring(0, p1.lastIndexOf('.'))
}

window.onload = startGame;


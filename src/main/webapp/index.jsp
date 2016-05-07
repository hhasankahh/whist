<!DOCTYPE HTML>
<html>
<head>
<style>
	div.position {
	    background-color: yellow;
		width:80px;height:100px;padding:10px;border:1px solid #aaaaaa;
		display:inline-block;
	}
	
	.center {
	    margin: auto;
	    width: 40%;
	    padding: 10px;
	}
	h3 {
		font-family: 'Avant Garde', Avantgarde, 'Century Gothic', CenturyGothic, AppleGothic, sans-serif;
		font-size: 24px;
		font-style: normal;
		font-variant: normal;
		font-weight: 500;
		line-height: 26.4px;
	}
	
	.applicationmessages {
		font-family: Rockwell, 'Courier Bold', Courier, Georgia, Times, 'Times New Roman', serif;
		font-size: 18px;
		font-style: normal;
		font-variant: normal;
		font-weight: 400;
		line-height: 18.5714px;
	}
</style>

<script src="knockout-3.4.0.js"></script>
<script src="jquery-1.12.3.js"></script>
</head>
<body>

<script>
	if(typeof(EventSource) !== "undefined") {
		var source = new EventSource('\whist');
		source.onmessage = function(e) {
			//alert(e.data);
			Update(e.data);
		}
	} else {
		document.getElementById("result").innerHTML = "Sorry, your browser does not support server-sent events...";
	}




/*   
   ----  JSON Structure to update the UI  ----
   
   Following fields should be included in the JSON string to 
   update the view properly
   
    cards -> an array of card objects representing the cards 
            in the players hand. Each card object should have 
			an image field with the file name of the card image.
			
	card1 -> String showing filename of the card played by each player.
	card2 -> String showing filename of the card played by each player.
	card3 -> String showing filename of the card played by each player.
    mycard ->  String showing filename of the card played by current player.
	showHand -> Boolean value stating whether the GUI should show cards in the players hand.
	showCards -> Boolean value stating whether the GUI should show the played cards. (card1, card2, card3, & mycard)
	message -> The status message that should be shown.
	
   These are some sample JSONs to represent the user interface.
   You should create the JSON for each player in the server and 
   send using AJAX poling or SSE or some other way.
   Then call the Update Function with that JSON string to update the UI.   
*/

var json1 = '{"cards":[],"showHand" : false, "showCards" : false , "message" : "Waiting for others to connect. Only 2 players connected .."}';
var json3 = '{"cards":[{"image": "cards/1_8.png" },{"image": "cards/2_11.png"},{"image": "cards/3_10.png"},{"image": "cards/1_5.png"},{"image": "cards/1_8.png"},{"image": "cards/3_12.png"},{"image": "cards/3_13.png"}] , "card1":"cards/3_4.png" , "card2":"cards/3_1.png","showHand" : true, "showCards" : true , "message" : "Play your card"}';
var json4 = '{"cards":[{"image": "cards/0_2.png" },{"image": "cards/1_2.png"},{"image": "cards/3_7.png"}] , "card1":"cards/3_4.png" , "card2":"cards/3_1.png", "mycard":"cards/2_2.png","showHand" : true, "showCards" : true , "message" : "Wait for others to play"}';
var json5 = '{"cards":[{"image": "cards/0_8.png" },{"image": "cards/1_13.png"},{"image": "cards/3_11.png"}] , "card1":"cards/2_4.png" , "card2":"cards/1_1.png","card3":"cards/2_11.png", "mycard":"cards/2_2.png","showHand" : true, "showCards" : true , "message" : "Calculating score"}';
var json6 = '{"cards":[{"image": "cards/0_8.png" },{"image": "cards/1_13.png"},{"image": "cards/3_11.png"}] , "showHand" : true, "showCards" : true , "message" : "Starting a new hand"}';

/* Updating the server on players moves */

/****************************************************** 
Edit these two functions to communicate with the server.
Hint -  you can use JQuery and Ajax here.
*******************************************************/

function PlayCard(card)
{
	  	var sendData = {"card":card};
	  //	alert(sendData);
	  	$.ajax({
	  	    type: 'POST',
	  	    url: '\whist',
	  	    data: sendData,
	  	    success: function(resp) { }
	  	});

}
/******************************************************/

</script>


<h3>Network card game</h3>
<div style = "margin-left:20">
<span data-bind="text: player" class="applicationmessages"></span>
</div>
<div style = "margin-left:20">
<span data-bind="text: currentScore" class="applicationmessages"></span>
</div>

<div>
<span data-bind="text: message" class="applicationmessages"></span>
</div>

<br/>
<div id="play"></div>



<!--cards-->
<br/>


<div data-bind="visible: shouldShowPlayedCards" id="playingBoard" class="center">

	<div class = "position" style = "margin-left: 110px;" >
	<img data-bind="attr: { src: card2 }" >
	</div>

	<br/>
	
	<div class = "position">
	<img data-bind="attr: { src: card1 }">
	</div>



	<div class = "position" style = "margin-left: 110px;">
	<img data-bind="attr: { src: card3 }">
	</div>

	<br/>

	<!-- Player's Card -->
	<div class = "position" style = "margin-left: 110px;">
	<img data-bind="attr: { src: mycard }">
	</div>
	
	<!-- trump -->
	<div class = "position" style = "margin-left: 100px;">
	<img data-bind="attr: { src: triumph }">
	</div>
</div> 
<br/>
	<div data-bind="foreach: cards , visible: shouldShowHand">
		<img data-bind="attr: { src: image }, click: function(data, event) { PlayCard(image)}"/>
	</div>
<br/>

<!-- TODO: These should be done automatically -->
<button onclick = "Update(json1)"> Loading view </button>
<button onclick = "Update(json3)"> Play card view </button>
<button onclick = "Update(json4)"> Wait for others </button>
<button onclick = "Update(json5)"> Finish hand </button>
<button onclick = "Update(json6)"> Start View </button>
<script>

// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function AppViewModel() {
    var self = this;
    self.cards = ko.observableArray([
        { image: 'cards/0_1.png' },
        { image: 'cards/1_2.png' },
        { image: 'cards/0_3.png' }
    ])
	self.card1 = ko.observable("cards/0_1.png");
	self.card2 = ko.observable("cards/0_1.png");
	self.card3 = ko.observable("cards/0_1.png");
	self.mycard = ko.observable("cards/0_1.png");
	self.triumph = ko.observable("cards/0_1.png");
	self.shouldShowHand = ko.observable(false);
	self.shouldShowPlayedCards = ko.observable(false);	
	self.message = ko.observable("waiting...");
	self.player = ko.observable("not assingned...")
	self.currentScore = ko.observable("0");
}

viewModel = new AppViewModel();
ko.applyBindings(viewModel);

function Update(statusJSON)
{
	var parsed = JSON.parse(statusJSON);
	viewModel.cards(parsed.cards);
	viewModel.card1(parsed.card1);
	viewModel.card2(parsed.card2);
	viewModel.card3(parsed.card3);
	viewModel.mycard(parsed.mycard);
	viewModel.shouldShowHand(parsed.showHand);
	viewModel.shouldShowPlayedCards(parsed.showCards);
	viewModel.message(parsed.message);
	viewModel.player(parsed.player);
	viewModel.triumph(parsed.triumph);
	viewMode.currentScore(parsed.currentScore);
}

</script>

</body>
</html>

	// config
baseSpeed = 0.01;
notchWidth = 0.1;
linePosition = 0
notchPosition = 0
clockwise = 0
//end config 

function setColor(color) {
	$("#shackle, #lock").css({"border-color": 'rgb(44 52 66)'});
}
function newNotch() {
	notchPosition = (((Math.random() * 0.75 * Math.PI) + 0.25 * Math.PI) * ((clockwise * 2) - 1)) + linePosition;
	$("#notch-dial").css({"-webkit-transform": "rotate(" + notchPosition + "rad)"});
	$("#notch-dial").css({"-moz-transform": "rotate(" + notchPosition + "rad)"});
	$("#notch-dial").css({"transform": "rotate(" + notchPosition + "rad)"});
	$("#notch").show();
	$("#notch").toggleClass("appear-b");
}
function setStatus(newStatus) {
	status = newStatus;
	switch (newStatus) {
  	case "start":
			if (level < 10) setColor("green");
			else if (level < 20) setColor("violet");
			else if (level < 30) setColor("orange");
			else if (level < 40) setColor("blue");
			else setColor("olive");
			setCount(level);
			linePosition = 0;
    	clockwise = true;
			newNotch();
			$("body").removeClass("fail");
      break;
    case "move":
      break;
		case "fail":
			close()
			document.getElementById("loadingbar").style.display = 'none';
			window.location.reload(false);
			$("#notch").hide();
			$("body").addClass("fail");
			break;
		case "win":
			$("#notch").hide();
			$("body").addClass("next");
			$("#shackle").addClass("unlock");
			close(true)
			setTimeout(function() {
				// setLevel(level + 1);
				// setStatus("start");
				$("#shackle").removeClass("unlock");
				document.getElementById("loadingbar").style.display = 'none';
				window.location.reload(false);
			}, 1000);
			setTimeout(function() {
				$("body").removeClass("next");
			}, 2000);
			break;
	} 
}
function setCount(newCount) {
	count = newCount;
	$("#lock").text(count);
}
function setLevel(newLevel) {
	level = newLevel;
	$("#level").text(level);
}
function click() {
	switch (status) {
		case "start":
			setStatus("move")
			break;
		case "move":
			if (Math.abs(Math.atan2(Math.sin(linePosition - notchPosition), Math.cos(linePosition - notchPosition))) < notchWidth) {
				setCount(count - 1);
				if (count == 0) {
					setStatus("win");
				}
				else {
					clockwise = !clockwise;
					newNotch();
				}
			}
			else {
				setStatus("fail");
			}
			break;
		case "fail":
			setStatus("start");
			break;
		case "win":
			setStatus("start");
			break;
	}
}
function step() {
	if (status == "move") linePosition += baseSpeed * (clockwise * 2 - 1);
	$("#line-dial").css({"-webkit-transform": "rotate(" + linePosition + "rad)"});
	$("#line-dial").css({"-moz-transform": "rotate(" + linePosition + "rad)"});
	$("#line-dial").css({"transform": "rotate(" + linePosition + "rad)"});
	if ((Math.atan2(Math.sin(linePosition - notchPosition), Math.cos(linePosition - notchPosition))) * (clockwise * 2 - 1) > notchWidth) setStatus("fail");
	window.requestAnimationFrame(step);
}

function close(result) {
	var xhr = new XMLHttpRequest();
	xhr.open("POST", 'https://renzu_lockgame/close', true);
	xhr.setRequestHeader('Content-Type', 'application/json');
	xhr.send(JSON.stringify({result:result}));
}
window.requestAnimationFrame(step);
window.addEventListener("mousedown", click);
window.addEventListener("touchstart", function(event) {
	event.preventDefault();
	click();
});
window.addEventListener("keydown", click);

var current = undefined
window.addEventListener('message', function (table) {
	let event = table.data;
	if (event.type == 'create') {
		if (event.table.hideshackle) {
			document.getElementById("shackle").style.display = 'none';
		}
		document.getElementById("loadingbar").style.display = 'block';
		setLevel(event.table.level || 10)
		setStatus("start");
	}
	if (event.type == 'reset') {
		document.getElementById("loadingbar").style.display = 'none';
		window.location.reload(false);
	}
});

$(document).on('keydown', function(event) {
	switch(event.keyCode) {
		case 27: // ESC
			setTimeout(function(){ window.location.reload(false);  }, 500);
			close()
			break;
		case 9: // TAB
			break;
		case 17: // TAB
			break;
	}
});
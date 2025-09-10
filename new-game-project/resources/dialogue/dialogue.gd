extends Resource

class_name Dialogue 

@export var dialogue = {}

func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogue = parsed_data
	else:
		dialogue = full_dialogue
		print("Error!")


# return correct NPC dialogue
func get_npc_dialogue(id):
	if id in dialogue:
		return dialogue[id]["tree"]
	else:
		return []


var full_dialogue = {
	"Mocha": {
		"tree" : [
			{
				"branch_id": "Mocha1.0",
				"text": ["Hey there Sandy! How you doing?",
						"What? Still don't like the nicknames I have for you? Heh.",
						"You'll get used to 'em!", 
						"Anyways, shop's always open for you buddy.",
						"As well as the fishing spot! Yknow where it is, right behind ya!",
						"Dunno why nobody else goes around there...",
						"I guess none of us like water, but you sure seem to love it!",
						"Well, it's been a few busy days with the tortoisse troubles but Mari's got them right now. What can I get for you?"],
				"quest": "Mocha0"
			},
			{
				"branch_id": "Mocha1.5",
				"text": ["Anything I can interest you in? Everythin's free as long as you get me some fish!"],
				"quest": "Mocha0"
			},
			{
				"branch_id": "Mocha2.0",
				"text": ["Hey Dustkitty! How ya doing?",
						"You've been playing with Nutmeg and Cinnamon? How sweet of ya!",
						"I know how much of a handful they can be, so thanks for helping Mari out.",
						"She wouldn't say, but I know those kids are tiring even her.",
						"I help out when I can but the shop's gotta keep running yknow..",
						"Heh. Well. Shop's open for ya kid!"
				],
				"quest": "Mocha1"
			},
			{
				"branch_id": "Mocha2.5",
				"text": ["Always here to service your every need, heh!"],
				"quest": "Mocha1"
			},
			{
				"branch_id": "Mocha3.0",
				"text": ["Arf, how's your day so far Pawsands?",
						"Heh, sounds like you're having a great time!",
						"Y'know it was in these very caverns I met my precious Goldie.",
						"I, of course, am born an' raised here, but her place was more...",
						"'proper'?",
						"Eh, it's the word her lot used. Not very nice 'em lot.",
						"But she melts you away. She really does.",
						"Been a bit emotional today, heh? Won't affect the shop though, still open!"
				],
				"quest": ""
			},
			{
				"branch_id": "Mocha3.5",
				"text": ["Remember, if you've got fish, I've got whatever you need!"],
				"quest": ""
			},
		]
	},
	"Marigold": {
		"tree" : [
			{
				"branch_id": "Marigold1.0",
				"text": ["Hello, lovely. How's the life up the island going?",
						"Aww, sweetheart, you know those crows give everyone trouble...",
						"I can tell you for sure, I've got enough troubles of my own!",
						"How about this - I've got a feather I found lying around, I'll give it to you if you manage to entertain my scoundrells for a bit.",
						"They're over there to the right."],
				"quest": "Marigold0"
			},
			{
				"branch_id": "Marigold1.5",
				"text": ["Maybe you could play their ball game with them? I have no idea what can keep them from asking me something every 10 seconds anymore..."],
				"quest": "Marigold0"
			},
			{
				"branch_id": "Marigold2.0",
				"text": ["Hm?",
						"Ah, sorry honey, just taking a quick cat-nap.",
						"You don't understand how lovely that bit of quiet was.",
						"Don't get me wrong, I love them to bits, and they can be the cutest, sweetest little ones.",
						"But Nutmeg's gotten the zoomies and won't step off that skateboard, and he wants attention every second!",
						"Cinnamon doesn't cause trouble, but he'll follow his brother anywhere.",
						"Including the sea.",
						"What an afternoon that was...",
						"Anyways. All is to say, thank you for entertaining them.",
						"And your feathered reward of course."
				],
				"quest": ""
			},
			{
				"branch_id": "Marigold2.5",
				"text": ["Yknow, you could keep playing with them, and I could keep sleeping for a bit... if you want of course!"],
				"quest": ""
			},
		]
	},
	"Nutmeg": {
		"tree" : [
			{
				"branch_id": "Nutmeg1.0",
				"text": ["MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOM",
						"THIS WEIRD SAND THING IS TALKING TO ME!!",
						"Oh.",
						"It's you.",
						"Sup Sandy! Wanna see a trick?",
						"OH OH WAIT NO - PLAY WITH ME!! JUST PRESS Q"
				],
				"quest": "Nutmeg0"
			},
			{
				"branch_id": "Nutmeg1.5",
				"text": ["C'MOOOOON!! PLAY WITH ME!!! PRESS Q!!!! Heh, I bet you can't get higher than 20!"],
				"quest": "Nutmeg0"
			},
			{
				"branch_id": "Nutmeg2.0",
				"text": ["Nice dude! That was a sick score!!",
						"Heh, maybe you're better than you look Sandy.",
						"Ha! You're literally made out of sand, c'mon you look weak!",
						"And you're like my size.",
						"But you're full grown.",
						"So.",
						"But no, no, you're good. Respect.",
						"Anyways.",
						"LET'S PLAY AGAIN!!!"
				],
				"quest": ""
			},
			{
				"branch_id": "Nutmeg2.5",
				"text": ["C'MOOOOON!! PLAY WITH ME!!!"],
				"quest": ""
			}
		]
	},
	"Cinnamon": {
		"tree" : [
			{
				"branch_id": "Cinnamon1.0",
				"text": ["......",
						"......",
						"......",
						"my brother's so cool..."
				],
				"quest": "Cinnamon0"
			},
			{
				"branch_id": "Cinnamon1.5",
				"text": ["woahhh..."],
				"quest": "Cinnamon0"
			},
			{
				"branch_id": "Cinnamon2.0",
				"text": ["That was so cool!",
						"I wanna play with my brother like that too...",
						"but I sprained my ankle...",
						"...",
						"it's okay, I can just watch for now..."
				],
				"quest": ""
			},
			{
				"branch_id": "Cinnamon2.5",
				"text": ["nutmeg's so cool..."],
				"quest": ""
			}
		]
	},
	"Misha": {
		"tree" : [
			{
				"branch_id": "Misha1.0",
				"text": ["Oh my god. Oh my god. Oh my god.",
						"We are missing everything.",
						"EVERYTHING!",
						"HOW IS THIS EVEN POSSIBLE???",
						"She's coming TODAY and all we have is a stage?!?",
						"No lighting, no cabling - NOT EVEN A MICROPHONE??",
						"This is it! The end of my career! Forget her coming back, she wont even be able to perform!",
						"And it's all my fault, and I-",
						"Hi Sandcat.",
						"I need help.",
						"Please, I'll give you anything! UH. A FEATHER?",
						"YES A FEATHER! Just find me some lights for this stage, please!"
				],
				"quest": "Misha0"
			},
			{
				"branch_id": "Misha1.5",
				"text": ["Lights. Yes. I guess that might be something Mocha has? Their shop's a true mismatch of things, you never know."],
				"quest": "Misha0"
			},
			{
				"branch_id": "Misha2.0",
				"text": ["AH! YES!! Those are perfect!",
						"You're a lifesaver!!",
						"Okay, while I set these up, I am in need of some cabling!",
						"Maybe somewhere with loads of crows? They always love to peck at them..."
				],
				"quest": "Misha1"
			},
			{
				"branch_id": "Misha2.5",
				"text": ["I think the left docks might be a good call? Thank you again!"],
				"quest": "Misha1"
			},
			{
				"branch_id": "Misha3.0",
				"text": ["HELL YEA! Look at you go! That's some cables right there!",
						"Okay. Okay this is fine. We've got things set up. We're just missing-",
						"WE'RE MISSING THE MICROPHONE.",
						"No one will be able to hear her over Nutmeg's screams!!",
						"OKAY. Just only last thing Sandcat! Then you've got your feather!",
						"Let's see. Microphone. Maybe it rolled between one of the cracks around here? Might be right below us."
				],
				"quest": "Misha2"
			},
			{
				"branch_id": "Misha3.5",
				"text": ["C'mon Sandcat! You can find one measely microphone! That this whole thing depends on. Ha, ha. Please."],
				"quest": "Misha2"
			},
			{
				"branch_id": "Misha4.0",
				"text": ["YOU. ARE. A. LIFESAVER!",
						"AHHHHH, that's such a relief you can't imagine!",
						"Truly thank you! Couldn't have done it without you!",
						"And of course, a feather for you! And a concert ticket obviously!",
						"Chappell Roar is gonna be AMAZING!"
				],
				"quest": ""
			},
			{
				"branch_id": "Misha4.5",
				"text": ["Thank you a million Sandcat!"],
				"quest": ""
			}
		]
	},
	"Brute": {
		"tree" : [
			{
				"branch_id": "Brute1.0",
				"text": ["Can't go further than this, dude."
				],
				"quest": "Brute0"
			},
			{
				"branch_id": "Brute1.5",
				"text": ["..."],
				"quest": "Brute0"
			},
			{
				"branch_id": "Brute2.0",
				"text": ["Are those snacks a bribe.",
						"...",
						"Eh, sure.",
						"...",
						"What? I'm hungry. And Mellow's not nice enough for me to care."
				],
				"quest": ""
			},
			{
				"branch_id": "Brute2.5",
				"text": ["..."],
				"quest": ""
			}
		]
	},
	"Mellow": {
		"tree" : [
			{
				"branch_id": "Mellow1.0",
				"text": ["UGH. How did YOU get in here?",
						"BRUTE?!?",
						"What? I'm not NICE enough??",
						"I'll show him nice after not doing the one thing he's HIRED for.",
						"UGH. The never of some people honestly.",
						"...",
						"What are you still doing here.",
						"Business? With those dirty dock rats?",
						"I have no business with such 'people'.",
						"...",
						"Poppies?",
						"I...",
						"Yes, tell them I'll take some."
				],
				"quest": "Mellow0"
			},
			{
				"branch_id": "Mellow1.5",
				"text": ["What?! Go! Get out of here!"],
				"quest": "Mellow0"
			},
			{
				"branch_id": "Mellow2.0",
				"text": ["You're back.",
						"I expect you have it?",
						"YES. Hand it over.",
						"...",
						"Still hanging around, Sandcat.",
						"Payment?",
						"Of course. Really no respect for the clients. Ugh.",
						"Here. Now LEAVE."
				],
				"quest": ""
			},
			{
				"branch_id": "Mellow2.5",
				"text": ["I already told you to get out of here!"],
				"quest": ""
			}
		]
	},
	"Mango": {
		"tree" : [
			{
				"branch_id": "Mango1.0",
				"text": ["Heyyyyy, how ya doing, Sandcat! My old pal!",
						"Hm, yes, yes.",
						"Okay. I have a business proposal for you.",
						"I have this feather I got on my own, very hard work you know, and in exchange for it all you have to do is one measely little delivery!",
						"Woah-ho! Let's not get ahead of ourselfs! Forget the what, let's get to the who - Mellow!",
						"Mellow, yes.",
						"Where is she?? Where she always is, that little alcove on the top floors.",
						"What do you mean you saw a bodyguard blocking the way.",
						"Really! I mean Nutmeg only threw a ball at her ONCE! And now she needs protection??",
						"What a snob- haha, nope Kiwi, I would never say that about a customer!",
						"Anyways. Bodyguard. Tall and orange?",
						"Kay, that's Brute. What was our bribe last time?",
						"Mm, fish didn't work though... WAIT I KNOW! A SNACK! I've seen him buying them from Mocha!",
						"Okay get five Sandcat, he's a big guy, then come back once you talk to Mellow - tell her we've got Poppies for her."
				],
				"quest": "Mango0"
			},
			{
				"branch_id": "Mango1.5",
				"text": ["C'mon Sandcat! Five snacks for Brute and he'll let you through! And talk to Mellow!"],
				"quest": "Mango0"
			},
			{
				"branch_id": "Mango2.0",
				"text": ["YES! NICE JOB SANDCAT!",
						"She said what about us.",
						"Kiwi you better hold me back, cause MELLOW IS GETTING-",
						"Right. Yes. Customer. Lovely.",
						"She does pay well, true.",
						"Okay, Sandcat, here's the stuff. Just gotta give it to her and come back with the payment.",
						"I expect it in FULL, Sandcat. We're friends but well. You know what happened to Papaya.",
						"Find a way to get it back if you spend it."
				],
				"quest": "Mango1"
			},
			{
				"branch_id": "Mango2.5",
				"text": ["C'mon Sandcat... you better get me that payment!"],
				"quest": "Mango1"
			},
			{
				"branch_id": "Mango3.0",
				"text": ["Always knew I could trust you, Sandcat!",
						"Well, a deal's a deal, here's your feather!"
				],
				"quest": ""
			},
			{
				"branch_id": "Mango3.5",
				"text": ["Always good having business with you."],
				"quest": ""
			}
		]
	},
	"Kiwi": {
		"tree" : [
			{
				"branch_id": "Kiwi1.0",
				"text": ["My brother sure's got the business spirit, ha.",
						"Y'know there wasn't really trade here before us.",
						"Built it from the ground.",
						"Who knew poppies would sell so well. Well. We sure did.",
						"And now it's the perfect base for growing them, and getting the shipments out.",
						"Glad you can help us out, ey."
				],
				"quest": "Kiwi0"
			},
			{
				"branch_id": "Kiwi1.5",
				"text": ["Getting to Mellow might be tricky, but we can count on you Sandcat."],
				"quest": "Brute0"
			},
			{
				"branch_id": "Kiwi2.0",
				"text": ["Some of these clients are really quite... something.",
						"Not much we can do. They're often the ones who keep paying.",
						"Come's with the business I suppose.",
						"Well thanks for the help Sandcat. We appreciate it."
				],
				"quest": ""
			},
			{
				"branch_id": "Kiwi2.5",
				"text": ["Yknow, you could always buy some as well? No? Ha! Guess it's not your style."],
				"quest": ""
			}
		]
	}
}

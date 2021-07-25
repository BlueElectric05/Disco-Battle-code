package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'sparks':
				FlxG.sound.playMusic(Paths.music('Disco theme'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.6);
			case 'resistance':
				FlxG.sound.playMusic(Paths.music('Disco theme'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.6);
			case 'shockwave':
				FlxG.sound.playMusic(Paths.music('Disco theme'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.6);
			

		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'sparks':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Portraits/discobox');
				box.animation.addByPrefix('normalOpen', 'boxopen', 24, false);
				box.animation.addByIndices('normal', 'box', [4], "", 24);
				box.x = 105;
				box.y = 430;
			
			case 'resistance':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Portraits/discobox');
				box.animation.addByPrefix('normalOpen', 'boxopen', 24, false);
				box.animation.addByIndices('normal', 'box', [4], "", 24);
				box.x = 105;
				box.y = 430;

			case 'shockwave':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Portraits/discobox');
				box.animation.addByPrefix('normalOpen', 'boxopen', 24, false);
				box.animation.addByIndices('normal', 'box', [4], "", 24);
				box.x = 105;
				box.y = 430;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(100, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('Portraits/thonyportrait');
		portraitLeft.animation.addByPrefix('enter', 'thony portrait', 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		portraitLeft.width = 50;
		portraitLeft.height = 50;

		portraitRight = new FlxSprite(700, 100);
		portraitRight.frames = Paths.getSparrowAtlas('Portraits/bfportrait');
		portraitRight.animation.addByPrefix('enter', 'bf portrait', 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		portraitLeft.width = 50;
		portraitLeft.height = 50;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(1050, 580);
		handSelect.frames = Paths.getSparrowAtlas('Portraits/speen');
		handSelect.animation.addByPrefix('ok button', 'ok button', 24, true);
		handSelect.animation.play('ok button');
		add(handSelect);


		if (!talkingRight)
		{
		    box.flipX = true;
		}

		dropText = new FlxText(222, 472, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Bank Gothic Medium BT';
		dropText.color = 0xE030FF;
		add(dropText);

		swagDialogue = new FlxTypeText(220, 472, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Bank Gothic Medium BT';
		swagDialogue.color = 0xFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ENTER  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'sparks' || PlayState.SONG.song.toLowerCase() == 'resistance' || PlayState.SONG.song.toLowerCase() == 'shockwave')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
						handSelect.alpha -= 1 / 5;
					}, 5);

                    
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}

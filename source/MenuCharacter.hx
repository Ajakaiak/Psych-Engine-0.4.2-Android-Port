pacote;

importar flixel.FlxSprite;
importar flixel.graphics.frames.FlxAtlasFrames;
#if MODS_ALLOWED
import sys.io.File;
importar sys.FileSystem;
#fim
importar openfl.utils.Assets;
importar haxe.Json;
importar haxe.format.JsonParser;

typedef MenuCharacterFile = {
	var imagem:String;
	var escala: Flutuante;
	var position:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
}

classe MenuCharacter estende FlxSprite
{
	public var caractere:String;
	private static var DEFAULT_CHARACTER:String = 'bf';

	função pública new(x:Float, caractere:String = 'bf')
	{
		super(x);

		changeCharacter(caractere);
	}

	função pública changeCharacter(?character:String = 'bf') {
		if(caracter == null) caractere = '';
		if(character == this.character) return;

		this.character = caractere;
		antialiasing = ClientPrefs.globalAntialiasing;
		visível = verdadeiro;

		var dontPlayAnim:Bool = false;
		escala.set(1, 1);
		atualizarHitbox();

		switch(caractere) {
			caso '':
				visível = falso;
				nãoPlayAnim = true;
			padrão:
				var characterPath:String = 'images/menucharacters/' + character + '.json';
				var rawJson = null;

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(caminho)) {
					caminho = Paths.getPreloadPath(characterPath);
				}

				if(!FileSystem.exists(caminho)) {
					caminho = Paths.getPreloadPath('images/menucharacters/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = File.getContent(path);

				#senão
				var path:String = Paths.getPreloadPath(characterPath);
				if(!Ativos.exists(caminho)) {
					caminho = Paths.getPreloadPath('images/menucharacters/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = Assets.getText(caminho);
				#fim
				
				var charFile:MenuCharacterFile = cast Json.parse(rawJson);
				frames = Paths.getSparrowAtlas('menucharacters/' + charFile.image);
				animação.addByPrefix('idle', charFile.idle_anim, 24);
				animation.addByPrefix('confirm', charFile.confirm_anim, 24, false);

				if(charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					atualizarHitbox();
				}
				offset.set(charFile.position[0], charFile.position[1]);
				animação.play('idle');
		}
	}
}
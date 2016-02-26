# NetManager that handle get and post action
ng_app.factory("Helper", [()->
	helper = {
		brief: (str, num=6)->
			unless str.length <= num
				str = str[0...num]+"..."
			str
	}
	helper;
]);
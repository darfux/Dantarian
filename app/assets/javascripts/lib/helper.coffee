# NetManager that handle get and post action
ng_app.factory("Helper", [()->
	d2h = (d)->
		s = (+d).toString(16);
		if s.length < 2
			s = '0' + s;
		s
	
	
	helper = {
		brief: (str, num=6)->
			unless str.length <= num
				str = str[0...num]+"..."
			str
		isbn2color: (isbn)->
			upper2N = (x, N=120)->
				Number(x<N)*N+x

			if isbn.length != 13 then return '#000'
			p1 = d2h(
				upper2N(+isbn[4..7]%0xff)
				)
			p2 = d2h(
				upper2N(+isbn[7..10]%0xff)
				)
			p3 = d2h(
				upper2N(+isbn[10..12]%0xff)
				)

			return "##{p1}#{p2}#{p3}"

	}
	helper;
]);
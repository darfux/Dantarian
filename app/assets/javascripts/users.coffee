# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@usersCtrl = angular.module('usersController', [])

using = (injects)->
	statement = ""
	for inject in injects.split(',')
		statement += "var #{inject} = this.#{inject};"
	statement

controllers = {}
controllers.record_books = ->
	eval(using('$scope, $window, NetManager, Helper'))

	location = $window.location
	update_list = ->
		NetManager.get(location.pathname+".json").then (data)->
			$scope.record_books = data.recent_record_books
			$scope.record_num = data.total_record_num

	$scope.counter_bottom_color = ->
		book = $scope.record_books[0]
		return null if !book
		color = Helper.isbn2color(book.isbn)
		color

	$scope.back = =>
		location.pathname = '/'
	

	# NTBI
	$scope.author_brief = (book)->
		Helper.brief(book.author, 12)
	
	$scope.ws = ws = new WebSocket("ws://#{location.host}#{location.pathname}/socket");
	ws.onopen    = ()->  
		console.log ('websocket opened')
	ws.onclose   = ()->
		console.log ('websocket closed')
	ws.onmessage = (m)->
		data = JSON.parse(m.data)
		console.log data
		msg = data.msg
		switch msg
			when 'update'
				update_list()
			when 'timeout'
				ws.close()
				location.pathname = data.redirect_to
			
		
	
	






dependencies = ['$scope', '$interval', '$window', 'NetManager', 'Helper']
# The main contoller logic
@usersCtrl.controller("UsersCtrl", dependencies.concat(
	($scope, $interval, $window, NetManager, Helper)->
		for i in [0..dependencies.length]
			this[dependencies[i]] = arguments[i]
		action = $('body').attr('action')
		controllers[action].call(this, arguments);	
))
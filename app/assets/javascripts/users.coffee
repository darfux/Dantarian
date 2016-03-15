# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@usersCtrl = angular.module('usersController', [])

using = (injects)->
	statement = ""
	for inject in injects.split(',')
		statement += "var #{inject} = this.#{inject};"
	console.log statement
	statement

controllers = {}
controllers.record_books = ->
	eval(using('$scope'))
	
	






dependencies = ['$scope', '$interval', '$window', 'NetManager']
# The main contoller logic
@usersCtrl.controller("UsersCtrl", dependencies.concat(
	($scope, $interval, $window, NetManager)->
		for i in [0..dependencies.length]
			console.log dependencies[i]
			this[dependencies[i]] = arguments[i]
		action = $('body').attr('action')
		controllers[action].call(this, arguments);	
))
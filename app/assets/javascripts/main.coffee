# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@mainCtrl = angular.module('mainController', []);


# The main contoller logic
@mainCtrl.controller("MainCtrl", ($scope, $interval, $window, NetManager)->
	# NetManager.get("http://www.jd.com").to($scope, 'jd')

)
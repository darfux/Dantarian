# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@sessionCtrl = angular.module('sessionController', []);

# The main contoller logic
@sessionCtrl.controller("UserSessionCtrl", ['$scope', '$interval', '$window', 'NetManager', ($scope, $interval, $window, NetManager)->
	# NetManager.get("http://www.jd.com").to($scope, 'jd')

	scope_attrs = {
	}

	angular.extend($scope, scope_attrs)



])
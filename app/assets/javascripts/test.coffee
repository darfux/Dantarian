# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@testCtrl = angular.module('testController', []);

@testCtrl.controller("TestCtrl", ['$scope', 'NetManager', ($scope, NetManager)->
	$scope.qr = ""
	NetManager.get('/users/access_token').to($scope, "qr")
])
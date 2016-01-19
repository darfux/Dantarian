# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@booksCtrl = angular.module('booksController', []);

# The main contoller logic
@booksCtrl.controller("BooksCtrl", ($scope, $interval, $window, NetManager)->
	# NetManager.get("http://www.jd.com").to($scope, 'jd')
	$scope.action = current_action();

)
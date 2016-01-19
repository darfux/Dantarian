# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@booksCtrl = angular.module('booksController', []);

# The main contoller logic
@booksCtrl.controller("BooksCtrl", ($scope, $interval, $window, NetManager)->
	# NetManager.get("http://www.jd.com").to($scope, 'jd')


	$scope.$watch('isbn', ->
		isbn = $scope.isbn
		if isbn && $scope.book_form.$valid
			NetManager.get('/books/sniffer', {isbn: isbn}).then (data)->
				$scope.cover = data.cover
				$scope.name = data.name

	)

	scope_attrs = {
		cover: ""
		action: current_action(),
		submit: (event)->
			console.log !$scope.book_form.$valid
			if !$scope.book_form.$valid
				event.preventDefault()
	}

	angular.extend($scope, scope_attrs)



)
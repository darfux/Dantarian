# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@mainCtrl = angular.module('mainController', []);


# The main contoller logic
@mainCtrl.controller("MainCtrl", ($scope, $interval, $window, NetManager)->

	$scope.$watch('book.isbn', ->
		$scope.error_msg = ""
		isbn = $scope.book.isbn
		if isbn && $scope.borrow_form.$valid
			NetManager.get('/books/sniffer', {isbn: isbn}).then (data)->
				$scope.book.cover = data.cover
				$scope.book.name = data.name
		else
			$scope.book = {}

	)

	scattrs = {
		book: {isbn: ''}
		isbn_pattern: /^\d+$/
		input_has_value: ->
			$scope.borrow_form.isbn.$viewValue
		input_is_correct: ()->
			!@input_has_value() || $scope.borrow_form.isbn.$valid
		handle_clear: ()->
			$scope.book = {}
			$('#isbn-input').val('')
			$scope.borrow_form.isbn.$viewValue = ""
		handle_borrow: (event)->
			if !$scope.borrow_form.$valid
				event.preventDefault()
			else
				console.log $scope.book
				NetManager.post('/books/borrow_by_isbn', {book: {book_info_attributes: $scope.book}}).then (data)->
					if data.status=='ok'
						$scope.book = {}
						$scope.borrowed_books = data.borrowed_books
					if data.status=='fail'
						if data.errno=='borrowed'
							u =  data.users[0]
							$scope.error_msg = "该书已被#{u.nickname}(#{u.account})借阅！"
	}

	angular.extend($scope, scattrs)
)
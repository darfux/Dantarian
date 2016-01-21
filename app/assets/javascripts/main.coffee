# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@mainCtrl = angular.module('mainController', []);


# The main contoller logic
@mainCtrl.controller("MainCtrl", ['$scope', '$interval', '$window', 'NetManager', ($scope, $interval, $window, NetManager)->

	$scope.$watch('book.isbn', ->
		$scope.error_msg = ""
		isbn = $scope.book.isbn
		if isbn && $scope.borrow_form.$valid
			$scope.book.searching = true
			NetManager.get('/books/sniffer', {isbn: isbn}).then (data)->
				$scope.borrow_btn = true if data.src != 'none'
				$scope.book.searching = false
				$scope.book.cover = data.cover
				$scope.book.name = data.name
				$scope.book.source = data.src
				$scope.book.show = true
		else
			$scope.book.show = false
			$scope.borrow_btn= false
	)

	scattrs = {
		book: {isbn: ''}
		isbn_pattern: /^\d+$/
		input_has_value: ->
			$scope.borrow_form.isbn.$viewValue
		input_is_correct: (allowempty)->
			allowempty = true if allowempty == undefined
			ret = (allowempty && !@input_has_value()) || $scope.borrow_form.isbn.$valid
		

		handle_clear: ()->
			$scope.book.isbn = null
			$('#isbn-input').val('')
			$scope.borrow_form.isbn.$viewValue = ""
			$scope.response_msg = ""
			$scope.borrow_btn = false


		handle_borrow: (event)->
			if !$scope.borrow_form.$valid
				event.preventDefault()
			else
				NetManager.post('/books/borrow_by_isbn', {book: {book_info_attributes: $scope.book}}).then (data)->
					$scope.borrow_btn = false
					$scope.book.borrow_state = data.status
					if data.status=='ok'
						$interval(
							->
								$scope.handle_clear()
								$scope.borrowed_books = data.borrowed_books
							,
							1000,1
						)
						$scope.response_msg = "借书成功！"
					if data.status=='fail'
						if data.errno=='borrowed'
							$scope.ok_btn = true
							u =  data.users[0]
							$scope.response_msg = "该书已被#{u.nickname}(#{u.account})借阅！"
		handle_ret: (book_id)->
			$scope.ret_book = book_id
			$scope.ret_timer = $interval(
							->
								NetManager.post('/books/ret', {book: {id: book_id}}).then (data)->
									console.log data
									$scope.ret_book = null
									$scope.borrowed_books = data.borrowed_books
							,
							1000,1
						)
		handle_cancel_ret: ->
			$scope.ret_book = null
			$interval.cancel($scope.ret_timer)
	}

	angular.extend($scope, scattrs)
])
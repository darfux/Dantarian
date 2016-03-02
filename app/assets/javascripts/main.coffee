# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@mainCtrl = angular.module('mainController', []);


# The main contoller logic
@mainCtrl.controller("MainCtrl", ['$scope', '$interval', '$window', 'NetManager', 'Helper', 'nodeValidator'
($scope, $interval, $window, NetManager, Helper, nodeValidator)->

	$scope.$watch('book.jd_id', ->
		jd_id = $scope.book.jd_id
		if jd_id &&　$scope.aio_form.$valid
			$scope.book.isbn = null
			$scope.book.searching = true
			NetManager.get('/books/jd_get_isbn', {item_id: jd_id}).to($scope.book, 'isbn')

	)

	$scope.$watch('book.isbn', ->
		$scope.error_msg = ""
		isbn = $scope.book.isbn
		$scope.book.show = false
		$scope.btn = {}
		if isbn && $scope.aio_form.$valid
			$scope.book.searching = true
			NetManager.get('/books/sniffer', {isbn: isbn}).then (data)->
				if data.src != 'none'
					unless $scope.ok.jd
						$scope.btn.borrow = true 
					$scope.btn.wish = true
				$scope.book.searching = false
				$scope.book.cover = data.cover
				$scope.book.name = data.name
				$scope.book.author = data.author
				$scope.book.source = data.src
				$scope.book.show = true

	)


	scattrs = {
		aio: {input: ''}
		book: {isbn: '', jd_id: null}
		ok: {}
		btn: {}

		
		input_is_correct: (allowempty)->
			allowempty = true if allowempty == undefined
			ret = (allowempty && !$scope.aio_form.input.$viewValue) ||  $scope.aio_form.$valid
			ret
		
		author_brief: (book)->
			Helper.brief(book.author, 12)

		handle_clear: ()->
			$scope.book = {isbn: '', jd_id: null}
			$('#aio-input').val('')
			$scope.aio.input = null
			$scope.aio_form.input.$viewValue = ""
			$scope.response_msg = ""
			$scope.btn = {}


		handle_borrow: (event)->
			if !$scope.aio_form.$valid
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
		handle_ret: (event, book_id)->
			return if event.button != 0
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
	$scope.ok = {}
	angular.extend($scope, scattrs)
])
.directive('allInOne', ['nodeValidator', (validator)->
	return {
		require: 'ngModel',
		restrict: 'A',
		link: (scope, element, attrs, controller)->
			# http://stackoverflow.com/questions/22639485/angularjs-how-to-change-the-value-of-ngmodel-in-custom-directive
			updateView = (value)->
				controller.$setViewValue(value)
				controller.$commitViewValue();
				controller.$render()

			updateModel = (value)->
				controller.$modelValue = value
				scope.ngModel = value # overwrites ngModel value

			controller.$validators.allInOne = (modelValue, viewValue)->
				if (controller.$isEmpty(modelValue))
					return true
				isbn_ok = validator.isISBN(modelValue)
				if isbn_ok
					scope.ok.isbn = true
					scope.book.isbn = modelValue
					return true
				
				if jd_url = viewValue.match(/(http(s|):\/\/|)item.jd.com\/(\d+).html/)
					item_id = jd_url[3]
					scope.book.jd_id = item_id
					value = 'JD-' + item_id
					updateView(value)

				jd_ok = viewValue.match(/JD\-(\d+)/)
				if jd_ok
					scope.ok.jd = true
					scope.book.jd_id = jd_ok[1]
					return true

				false
	};
])
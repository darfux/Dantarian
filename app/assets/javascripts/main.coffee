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
				if data.source != 'none'
					unless $scope.ok.jd
						$scope.btn.borrow = true 
					$scope.btn.wish = true
				$scope.book.searching = false
				$scope.book.cover = data.cover
				$scope.book.name = data.name
				$scope.book.author = data.author
				$scope.book.source = data.source
				$scope.book.favored = data.favored
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
		
		get_book_parm: ->
			{book: {book_info_attributes: angular.copy($scope.book)}}
		
		author_brief: (book)->
			Helper.brief(book.author, 12)

		handle_paste: ()->
			$scope.book = {isbn: '', jd_id: null}
			$scope.ok = {}
		
		handle_clear: ()->
			$scope.book = {isbn: '', jd_id: null}
			$('#aio-input').val('')
			$scope.aio.input = null
			$scope.aio_form.input.$viewValue = ""
			$scope.response_msg = ""
			$scope.btn = {}

		handle_favor: (book)->
			return if $scope.book.favoring
			$scope.book.favoring = true
			NetManager.post(
				'/books/favor', {isbn: book.isbn, favored: book.favored}).then (data)->
					book.favored = data.favored
					$interval(
						->
							$scope.handle_clear()
							if data.book_list
								$scope.related_books = data.book_list
						,
						250,1
					)

		handle_borrow: (event)->
			NetManager.post('/books/borrow_by_isbn', @get_book_parm()).then (data)->
				$scope.btn = {}
				$scope.book.borrow_state = data.status
				if data.status=='ok'
					$interval(
						->
							$scope.handle_clear()
							$scope.related_books = data.related_books
						,
						500,1
					)
					$scope.response_msg = "借书成功！"

				if data.status=='fail'
					if data.errno=='borrowed'
						u =  data.users[0]
						$scope.response_msg = "该书已被#{u.nickname}(#{u.account})借阅！"
					if data.errno=='no_copy'
						$scope.response_msg = "该书尚未购入"
					$scope.btn = {known: true}

		handle_ret: (event, book_id)->
			return if event.button != 0
			$scope.ret_book = book_id
			$scope.ret_timer = $interval(
							->
								NetManager.post('/books/ret', {book: {id: book_id}}).then (data)->
									console.log data
									$scope.ret_book = null
									$scope.related_books = data.related_books
							,
							1000,1
						)
		handle_cancel_ret: ->
			$scope.ret_book = null
			$interval.cancel($scope.ret_timer)


	}
	$scope.ok = {}
	angular.extend($scope, scattrs)

	# AIO_TIPS = [
	# 	"输入ISBN借阅书籍",
	# 	"输入京东链接加入愿望单",
	# ]
	# tip_idx = 0
	# $scope.aio_tip = AIO_TIPS[tip_idx++]
	# $interval(
	# 	->
	# 		$scope.aio_tip = AIO_TIPS[tip_idx]
	# 		tip_idx++; tip_idx %= AIO_TIPS.length
	# 	,
	# 	3000
	# )
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
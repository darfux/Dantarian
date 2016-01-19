@ng_app = angular.module(
  'Dantarian',
  [
  	'mainController',
  	'booksController',
  ]
);

# http://kurtfunai.com/2014/08/angularjs-and-turbolinks.html
# https://docs.angularjs.org/error/ng/btstrpd
$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['Dantarian'])
)
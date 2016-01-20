var ng_app = angular.module(
  'Dantarian',
  [
  	'mainController',
  	'booksController',
  ]
);

$(document).on('ready page:load', function(){
  angular.bootstrap(document, ['Dantarian'])
})
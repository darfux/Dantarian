@ng_app = angular.module(
  'Dantarian',
  [
  	'angular.validators',
  	'mainController',
  	'booksController',
  ]
).config(["$httpProvider", (provider)->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
]);

# http://kurtfunai.com/2014/08/angularjs-and-turbolinks.html
# https://docs.angularjs.org/error/ng/btstrpd
$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['Dantarian'])
)
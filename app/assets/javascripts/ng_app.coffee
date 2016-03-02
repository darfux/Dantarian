@ng_app = angular.module(
	'Dantarian',
	[
		'ngAnimate',
		'ngMdIcons',
		'ngResource',
		'angular.validators',
		'sessionController',
		'mainController',
		'booksController',
	]
).config(["$httpProvider", '$resourceProvider', (provider, resource)->
	provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	resource.defaults.stripTrailingSlashes = false;
]);

# http://kurtfunai.com/2014/08/angularjs-and-turbolinks.html
# https://docs.angularjs.org/error/ng/btstrpd
$(document).on('ready page:load', ->
	angular.bootstrap(document.body, ['Dantarian'])
)
root = exports ? this

# A tool class to make JS.promise easier to use in angular
CusPromise = (promise_)->
	obj = {
		to: (target, attr, callback)->
			this.promise.then((data)->
				if data.data!=undefined && data.result!=undefined && data.msg!=undefined
					target[attr] = data.data;
					callback && callback.call(this, target[attr], data.result, data.msg);
				else
					target[attr] = data;
					callback && callback.call(this, target[attr]);
			);
			return promise_;
		,
		then: (callback)->
			this.promise.then callback
		,
		promise: promise_
	}
	return obj;


# NetManager that handle get and post action
ng_app.factory("NetManager", ['$q', '$http', ($q, $http)->
	net = {
		get: (url, params_, flag)->
			deferred = $q.defer();
			base = '';
			$http.get(base + url,
				{params: params_}
			).
			success((data)->
				deferred.resolve(data);
			);
			return CusPromise(deferred.promise);
		,
		post: (url, data_, flag)->
			deferred = $q.defer();
			base = '';
			$http.post(base + url, data_).
			success((data)->
				deferred.resolve(data);
			).
			error((data)->
				alert('操作失败！');
			);
			deferred.promise;
	}
	net;
]);
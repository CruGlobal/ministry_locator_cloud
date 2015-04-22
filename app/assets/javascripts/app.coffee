angular.module( 'ml.services', [] )
angular.module( 'ml.controllers', ['autocomplete'] )
angular.module( 'ml', ['ml.controllers', 'ml.services'] )